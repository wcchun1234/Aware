import csv

# Read in the input CSV file
with open('Data_visualization.csv', 'r', encoding='ISO-8859-1') as csvfile:
    reader = csv.reader(csvfile)
    row_list = []
    for row in reader:
        if len(row) == 0 or row[0].strip() == '':
            continue
        first_word = row[0].split()[0]
        row_list.append([first_word])

# Write the output to a new CSV file
with open('output_Data_visualization.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerows(row_list)
