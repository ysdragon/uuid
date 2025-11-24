#include "uuid.h"

uuids::uuid_random_generator &get_uuid_generator()
{
	static std::random_device rd;
	static auto seed_data = std::array<int, std::mt19937::state_size>{};
	static bool seeded = false;

	if (!seeded)
	{
		std::generate(std::begin(seed_data), std::end(seed_data), std::ref(rd));
		seeded = true;
	}

	static std::seed_seq seq(std::begin(seed_data), std::end(seed_data));
	static std::mt19937 generator(seq);
	static uuids::uuid_random_generator gen{generator};
	return gen;
}

extern "C"
{
#include "ring.h"

	RING_FUNC(ring_uuid_generate)
	{
		try
		{
			uuids::uuid const id = get_uuid_generator()();

			std::string s = uuids::to_string(id);

			RING_API_RETSTRING(s.c_str());
		}
		catch (...)
		{
			RING_API_ERROR("Internal C++ Exception in uuid_generate");
		}
	}

	RING_FUNC(ring_uuid_nil)
	{
		uuids::uuid const id;
		std::string s = uuids::to_string(id);
		RING_API_RETSTRING(s.c_str());
	}

	RING_FUNC(ring_uuid_isvalid)
	{
		if (RING_API_PARACOUNT != 1)
		{
			RING_API_ERROR(RING_API_MISS1PARA);
			return;
		}

		if (RING_API_ISSTRING(1))
		{
			const char *cStr = RING_API_GETSTRING(1);

			bool isValid = uuids::uuid::is_valid_uuid(cStr);

			RING_API_RETNUMBER(isValid ? 1 : 0);
		}
		else
		{
			RING_API_ERROR(RING_API_BADPARATYPE);
		}
	}

	RING_FUNC(ring_uuid_tobytes)
	{
		if (RING_API_PARACOUNT != 1)
		{
			RING_API_ERROR(RING_API_MISS1PARA);
			return;
		}

		if (RING_API_ISSTRING(1))
		{
			const char *cStr = RING_API_GETSTRING(1);
			auto result = uuids::uuid::from_string(cStr);

			if (result.has_value())
			{
				auto bytes = result.value().as_bytes();
				RING_API_RETSTRING2(reinterpret_cast<const char *>(bytes.data()), bytes.size());
			}
			else
			{
				RING_API_ERROR("Invalid UUID string format");
			}
		}
		else
		{
			RING_API_ERROR(RING_API_BADPARATYPE);
		}
	}

	RING_LIBINIT
	{
		RING_API_REGISTER("uuid_generate", ring_uuid_generate);
		RING_API_REGISTER("uuid_nil", ring_uuid_nil);
		RING_API_REGISTER("uuid_isvalid", ring_uuid_isvalid);
		RING_API_REGISTER("uuid_tobytes", ring_uuid_tobytes);
	}
}