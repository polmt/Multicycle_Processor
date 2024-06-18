import struct

# Use 'rb' mode for reading binary files
with open(r'Path\to\TEST.BIN', 'rb') as read_file:
    with open(r'Path\to\TEST.txt', 'w') as write_file:
        # Read 4 bytes at a time from the binary file
        chunk = read_file.read(4)
        count = 0

        while chunk:
            # Convert from Big Endian to Little Endian (4 bytes = 'I' format)
            little_endian_value = struct.unpack('<I', chunk)[0]

            # Formatting for new lines and tabs
            if count % 4 == 0:
                if count > 0:
                    write_file.write('\n')
                write_file.write('\t')

            # Write the converted value in hexadecimal format
            write_file.write(f'X"{little_endian_value:08X}", ')

            # Read the next 4 bytes
            chunk = read_file.read(4)
            count += 1

        # Ensure the last comma is not a problem for whatever will use this file
        # This step might depend on how the output file is intended to be used
