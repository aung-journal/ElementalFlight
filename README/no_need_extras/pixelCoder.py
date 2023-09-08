from PIL import Image

# Load the image
image = Image.open('player1.png')

# Define the hex color you want to change and the new hex color
old_hex_color = "#5B6EE1"  # Replace with the hex color you want to change
new_hex_color = "#AC3232"  # Replace with the hex color of the new color

# Convert hex color strings to RGB tuples
old_color = tuple(int(old_hex_color[i:i+2], 16) for i in (1, 3, 5))
new_color = tuple(int(new_hex_color[i:i+2], 16) for i in (1, 3, 5))

# Get image data as a list of pixels
pixel_data = list(image.getdata())

# Convert the data to a mutable list
pixel_data = [list(pixel) for pixel in pixel_data]

# Loop through each pixel and change the color if it matches the old color
for pixel in pixel_data:
    if tuple(pixel) == old_color:
        pixel[:] = new_color

# Update the image data
image.putdata([tuple(pixel) for pixel in pixel_data])

# Save the modified image
image.save('player1.png')
