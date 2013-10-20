/*
The MIT License (MIT)

Copyright (c) 2013 Michael Lancaster

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

/* Program to test SMT performance on factorial and fibonnaci programs
 * Used to generate IBM POWER7 comparison results for
 * M. Lancaster, A hardware investigation of simultaneous multi-threading,
 * October, 2013.
 * Untested on Intel SMT architectures due to my CPU not supporting HyperThreading
 * (i5-3570K).
 * Michael Lancaster <mjl152@uclive.ac.nz>.
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>

#ifdef _MSC_VER
#include <windows.h>
#include <process.h>
#else
#include <pthread.h>
#endif


const uint32_t ITERATIONS = 10000000000;
const uint8_t NUM_THREADS = 1;
uint64_t complete[2] = { 0, 0 };

void fib_msc(void * argument) {
	uint32_t iterations = ITERATIONS;
	uint32_t n = 1000;
	int8_t i = 0;
	uint32_t iters = 0;
	uint64_t secondprev = 0;
	uint64_t firstprev = 1;
	uint64_t intermediate;
	while (iters < iterations) {
		intermediate = firstprev;
		firstprev += secondprev;
		secondprev = intermediate;
		i++;
		iters++;
	}
	if (firstprev == 0) {
		complete[0] = 1;
	}
	else {
		complete[0] = firstprev;
	}
}

void * fib(void * argument) {
	fib_msc(argument);
	return NULL;
}

void fact(void * argument) {
	uint64_t iterations = ITERATIONS;
	uint64_t n = 1000;
	uint64_t result = n;
	uint64_t iters = 0;
	while (iters < iterations) {
		n--;
		result = result * n;
		iters++;
	}
	if (result == 0) {
		complete[1] = 1;
	}
	else {
		complete[1] = result;
	}
}


int main(void) {
	clock_t begin, end;
	double time_spent;
	begin = clock();
	uint32_t arguments[2] = { ITERATIONS, 1000 };
#ifdef _MSC_VER
#else
	pthread_t threads[NUM_THREADS];
#endif
	if (NUM_THREADS == 1) {
		fib((void *) &arguments);
		fact((void *)&arguments);
	}
	else {
#ifdef _MSC_VER
		_beginthread(fib_msc, 0, (void *)&arguments);
#else
		pthread_create(&threads[0], NULL, fib, (void *)&arguments);
#endif
		fact(&arguments);
	}
	while ((complete[0] == 0) || (complete[1] == 0)) {
		fprintf(stdout, " \b");
	}
	end = clock();
	time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
	fprintf(stdout, "\nTime spent: %f\n", time_spent);
	fflush(stdout);
	return EXIT_SUCCESS;
}

