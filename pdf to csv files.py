import csv
import os
import re
from pdfminer.high_level import extract_text

## list of input files
input_files = ['Data_visualization_{}.pdf'.format(i) for i in range(1,11)]

## list to hold all lines from all PDF files
all_lines = []

for input_file in input_files:
    ## extract all the text from the input file
    text = extract_text(input_file)

    ## filter out the url element
    pattern = re.compile(r'\bhttps?:\/\/[^\s]+')
    text = pattern.sub('',text)

    ## filter out all punctuation
    text = re.sub(r'[^\w\s]','',text)

    ## split the text into lines
    lines = text.split('\n')

    ## append the lines to the list of all lines
    all_lines.extend(lines)

    print(all_lines)

## create a CSV file to hold all the lines
output_file = 'Data_visualization.pdf.csv'
with open(output_file, 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    for line in all_lines:
        writer.writerow([line])
