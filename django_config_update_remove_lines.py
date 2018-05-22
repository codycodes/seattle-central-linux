settings_file_read = open("/path/to/file", "r+")
count = 0
remove_line = False

new_settings_file = ""

for line in settings_file_read:
    if "DATABASES = {" in line:
        remove_line = True

    if remove_line:
        if "{" in line:
            count = count + 1
        if "}" in line:
            count = count - 1
        settings_file_read.next()
        if count == 0:
            remove_line = False
    else:
        new_settings_file = new_settings_file + line

settings_file_read.close()

settings_file_write = open("/path/to/file", "w")
settings_file_write.write(new_settings_file)
