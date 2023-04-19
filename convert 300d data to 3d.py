import pandas as pd
import numpy as np
from sklearn.manifold import TSNE
import ast

# Read the CSV file, assuming it has headers
data = pd.read_csv("embedded_data.csv", header=0)

print("Original data:")
print(data)

# Convert the embeddings from strings to lists of numeric values
data['embedding'] = data['embedding'].apply(ast.literal_eval)

# Assuming each row represents a word embedding
word_embeddings = data['embedding'].tolist()

# Print the number of samples
print(f"\nNumber of samples: {len(word_embeddings)}")

# If there are no samples, exit
if len(word_embeddings) == 0:
    print("No valid samples found.")
    exit()

# Dimensionality reduction using t-SNE
word_embeddings = np.array(word_embeddings)
tsne = TSNE(n_components=3, perplexity=5)  # You can try a smaller value for perplexity
coordinates_3d = tsne.fit_transform(word_embeddings)

# Save the 3D coordinates to a new CSV file
reduced_data = pd.DataFrame(coordinates_3d, columns=['x', 'y', 'z'])
reduced_data['text'] = data['text']  # Add the 'text' column to the reduced_data DataFrame
reduced_data = reduced_data[['text', 'x', 'y', 'z']]  # Reorder the columns
reduced_data.to_csv("reduced_embedded_data.csv", index=False)
