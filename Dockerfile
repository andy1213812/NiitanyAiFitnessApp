# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /NiitanyAIFitnessApp

# Copy the current directory contents into the container at /app
COPY . /NiitanyAIFitnessApp

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Make port 5000 available to the world outside this container
EXPOSE 8080

# Define environment variable
ENV MODEL_PATH LSTM.h5

# Run app.py when the container launches
CMD ["python", "app.py"]
