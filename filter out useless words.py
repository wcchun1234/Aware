import csv

# Define the list of useless words
useless_words = ['Up', 'Very', 'want', 'A', 'is', 'Their', 'Example', 'NOTE', 'AT', 'modes', 'The', 'we', 'we', 'Its', 'you', 'need', 'You', 'own', 'Grove', 'Handson', 'Plotting', 'comwatchv2wbZU', 'sK6h0I', 'Controlling', 'atchvE1w7dL3Cps', 'Low', 'BLE', 'operating',
                 'a', 'an', 'the', 'and', 'but', 'or', 'so', 'for', 'with', 'at', 'by', 'from', 'in', 'into', 'on', 'to', 'up', 'down', 'off', 'out', 'over', 'under', 'above', 'below', 'between', 'among', 'through', 'throughout', 'before', 'after', 'during', 'since', 'until', 'while', 'because', 'if', 'when', 'where', 'how', 'what', 'which', 'who', 'whom', 'whose', 'that', 'this', 'these', 'those', 'he', 'she', 'it', 'we', 'they', 'me', 'him', 'her', 'them', 'my', 'your', 'his', 'her', 'its', 'our', 'their', 'than', 'be', 'do', 'as']

# Open the input CSV file and create an output file to write the filtered text
with open('output_Data_visualization.csv', 'r') as input_file, open('filtered_Data_visualization.csv', 'w', newline='') as output_file:
    reader = csv.reader(input_file)
    writer = csv.writer(output_file)

    # Iterate through each row in the input file
    for row in reader:
        # Check if the row contains only single-letter words or numbers
        if all(len(text) == 1 or text.isnumeric() for text in row):
            continue

        filtered_row = []

        # Iterate through each text in the row and add it to the filtered_row if it's not a useless word, a single letter, or a number, and if it hasn't been added to filtered_row before
        for text in row:
            if len(text) > 1 and not text.isnumeric() and text not in useless_words and text not in filtered_row:
                filtered_row.append(text)

        # Write the filtered_row to the output file
        writer.writerow(filtered_row)
