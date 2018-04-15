# remove all sudos from history copying to make script automation easier
code= """
sudo hello, world
"""

print(code.replace("sudo", ""))
