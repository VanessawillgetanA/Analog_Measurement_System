#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main() {

    const char* filename = "data/processed/measurement_data.csv";

    FILE* file = fopen(filename, "r");

    if (file == NULL) {
        printf("Error: Could not open measurement_data.csv\n");
        return 1;
    }

    char line[256];

    // Skip CSV header
    fgets(line, sizeof(line), file);

    int count = 0;

    double sum_vin = 0.0;
    double sum_vout = 0.0;

    double min_vin = 1e9;
    double max_vin = -1e9;

    double min_vout = 1e9;
    double max_vout = -1e9;

    double sum_vin_squared = 0.0;
    double sum_vout_squared = 0.0;

    double time;
    double vin;
    double vout;

    while (fgets(line, sizeof(line), file) != NULL) {

        if (sscanf(line, "%lf,%lf,%lf", &time, &vin, &vout) == 3) {

            sum_vin += vin;
            sum_vout += vout;
            if (vin < min_vin) min_vin = vin;
            if (vin > max_vin) max_vin = vin;

            if (vout < min_vout) min_vout = vout;
            if (vout > max_vout) max_vout = vout;
            sum_vin_squared += vin * vin;
            sum_vout_squared += vout * vout;

            count++;
        }
    }

    fclose(file);

    double mean_vin = sum_vin / count;
    double mean_vout = sum_vout / count;

    double rms_vin = sqrt(sum_vin_squared / count);
    double rms_vout = sqrt(sum_vout_squared / count);

    double peak_to_peak_vin = max_vin - min_vin;
    double peak_to_peak_vout = max_vout - min_vout;

    double peak_vin = fmax(fabs(min_vin), fabs(max_vin));
    double peak_vout = fmax(fabs(min_vout), fabs(max_vout));

    printf("CUDA signal analysis starting...\n");
    printf("Loaded %d measurement samples.\n", count);

    printf("Mean Vin  = %.8f V\n", mean_vin);
    printf("Mean Vout = %.8f V\n", mean_vout);

    printf("RMS Vin   = %.8f V\n", rms_vin);
    printf("RMS Vout  = %.8f V\n", rms_vout);

    double rms_gain = rms_vout / rms_vin;

    printf("RMS Gain  = %.6f\n", rms_gain);
    printf("RMS Gain  = %.2f dB\n", 20.0 * log10(rms_gain));

    printf("Vin Peak-to-Peak  = %.8f V\n", peak_to_peak_vin);
    printf("Vout Peak-to-Peak = %.8f V\n", peak_to_peak_vout);

    printf("Vin Peak Voltage  = %.8f V\n", peak_vin);
    printf("Vout Peak Voltage = %.8f V\n", peak_vout);

    FILE* results = fopen("results/cuda_analysis.txt", "w");

    if (results == NULL) {
        printf("Error: Could not create CUDA results file.\n");
        return 1;
    }

    fprintf(results, "CUDA Analog Measurement Analysis\n");
    fprintf(results, "================================\n");
    fprintf(results, "Samples: %d\n\n", count);

    fprintf(results, "Mean Vin: %.8f V\n", mean_vin);
    fprintf(results, "Mean Vout: %.8f V\n\n", mean_vout);

    fprintf(results, "RMS Vin: %.8f V\n", rms_vin);
    fprintf(results, "RMS Vout: %.8f V\n\n", rms_vout);

    fprintf(results, "RMS Gain: %.6f\n", rms_gain);
    fprintf(results, "RMS Gain: %.2f dB\n\n", 20.0 * log10(rms_gain));

    fprintf(results, "Vin Peak-to-Peak: %.8f V\n", peak_to_peak_vin);
    fprintf(results, "Vout Peak-to-Peak: %.8f V\n\n", peak_to_peak_vout);

    fprintf(results, "Vin Peak: %.8f V\n", peak_vin);
    fprintf(results, "Vout Peak: %.8f V\n", peak_vout);

    fclose(results);

    printf("Results saved to results/cuda_analysis.txt\n");

    return 0;
}