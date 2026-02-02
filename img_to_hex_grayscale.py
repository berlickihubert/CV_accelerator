from PIL import Image
import os

def png_to_mif():
    input_png = r"C:\Users\berli\Desktop\studia\fpga\projekt\group_portrait_15.jpg"
    output_mif = r"C:\Users\berli\Desktop\studia\fpga\projekt\img320x240.mif"

    if not os.path.exists(input_png):
        print(f"Input file {input_png} does not exist.")
        return

    img = Image.open(input_png).convert("L")

    if img.size != (320, 240):
        img = img.resize((320, 240))


    pixels = list(img.getdata())
    depth = len(pixels)

    with open(output_mif, "w") as f:
        f.write(f"DEPTH = {depth};\n")
        f.write("WIDTH = 8;\n")
        f.write("ADDRESS_RADIX = HEX;\n")
        f.write("DATA_RADIX = HEX;\n")
        f.write("CONTENT\n")
        f.write("BEGIN\n")

        for address, pixel in enumerate(pixels):
            f.write(f"{address:X} : {pixel:02X};\n")

        f.write("END;\n")


if __name__ == "__main__":
    png_to_mif()
    print("Converted PNG to MIF format.")
