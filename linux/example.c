#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <linux/easynmc.h>
#include <easynmc.h>

int main(int argc, char **argv)
{
	int ret;
	uint32_t entrypoint;
	if (argc < 1) {
		fprintf(stderr, "USAGE: %s filename.abs");
		exit(1);
	}

	struct easynmc_handle *h = easynmc_open(0);
	if (!h) {
		fprintf(stderr, "Failed to open nmc core \n");
		exit(1);
	}

	int state;
	if ((state = easynmc_core_state(h)) != EASYNMC_CORE_IDLE) {
		fprintf(stderr, "Core is %s, expecting core to be idle\n", easynmc_state_name(state));
		exit(1);
	}

	ret = easynmc_load_abs(h, argv[1], &entrypoint, ABSLOAD_FLAG_DEFAULT);
	if (0 != ret) {
		fprintf(stderr, "Failed to upload abs file\n");
		exit(1);
	}

	ret = easynmc_pollmark(h);

	if (ret != 0) {
		fprintf(stderr, "Failed to reset polling counter (\n");
		exit(1);
	};

	ret = easynmc_start_app(h, entrypoint);
	if (ret != 0) {
		fprintf(stderr, "Failed to start app (\n");
		exit(1);
	}
	printf("NMC application started, waiting up to 5 seconds\n");
	int timeout = 5;
	do {
		state = easynmc_core_state(h);
		printf("Current NMC core state: %d\n", state);
		if (state == EASYNMC_CORE_IDLE)
			break;
		sleep(1);
	} while (timeout--);

	printf("App exited, bailing out\n");
	exit (timeout == 0);
}
