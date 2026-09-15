from pathlib import Path

input_file = Path("data/raw/measurement_output.txt")
output_file = Path("data/processed/measurement_data.csv")

rows = []

with input_file.open("r") as file:
    for line in file:
        parts = line.split()

        if len(parts) == 4 and parts[0].isdigit():
            index, time, vin, vout = parts

            rows.append(
                f"{time},{vin},{vout}\n"
            )

with output_file.open("w") as file:
    file.write("time,vin,vout\n")
    file.writelines(rows)

print(f"Processed {len(rows)} measurement samples.")
print(f"Saved to: {output_file}")