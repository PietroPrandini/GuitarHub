#!/usr/bin/python3

# Library for executing shell commands
import subprocess

# Library for communicating to the operating system
import os

# Library for properties of the system
import sys

min_python_version = 3
if sys.version_info[0] < min_python_version:
    exit("This generator needs runnig at least with python3.\n"
        + "Now it's using python "
        + "\""
        + str(sys.version_info[0]) + "." + str(sys.version_info[1])
        + "\"\n\n"
        + "Try with:\n"
        + "python3 GuitarHubGenerator.py\n",
    )
else:
    print("It's using python "
    + "\""
    + str(sys.version_info[0]) + "." + str(sys.version_info[1])
    + "\"\n")

# Checks if the current directory is compatible with the environment
# param dir The last dir of the working directory path
# return TRUE if the current directory is compatible
# return FALSE if the current directory is not compatible
def currentdirectorycheck(dir):
    # Checks the current working directory
    current_working_directory = os.getcwd()
    # If not the directory where building the book then exit
    if (current_working_directory[-(len(dir)):] == dir):
        # The working directory is compatible
        return True;
    else:
        # The working directory isn't compatible
        return False;

# Updates the copyright of a song
# param filepath The path of the song file
def updatesongcopyright(filepath):
    print("Updating the copyright of \"" + filepath + "\"")
    # Opens the song file
    file = open(filepath, "r")

    # Retrieves a copy of the file
    filetolines = file.readlines()

    lineofbeginsong = -1
    lineofoptionsstart = -1
    lineofoptionsstop = -1

    for line in range(len(filetolines)):
        if lineofbeginsong == -1:
            indexofbeginsong = filetolines[line].find("beginsong")
            if indexofbeginsong != -1:
                lineofbeginsong = line
                break
    if lineofbeginsong == -1:
        print("No beginsong in \"" + filepath + "\"")
        return
    print("lineofbeginsong " + str(lineofbeginsong))

    for line in range(lineofbeginsong, len(filetolines)):
        if lineofoptionsstart == -1:
            indexofoptionsstart = filetolines[line].find("[")
            if indexofoptionsstart != -1:
                lineofoptionsstart = line
                break
    print("lineofoptionsstart " + str(lineofoptionsstart))

    for line in range(lineofoptionsstart, len(filetolines)):
        if lineofoptionsstop == -1:
            indexofoptionsstop = filetolines[line].find("]")
            if indexofoptionsstop != -1:
                lineofoptionsstop = line
                break
    print("lineofoptionstop " + str(lineofoptionsstop))

    # prepares the copyright string
    copyright = ",cr={\\centering{\\href{https://github.com/PietroPrandini/GuitarHub}{https://github.com/PietroPrandini/GuitarHub} - \\href{http://creativecommons.org/licenses/by-sa/4.0/}{CC-BY-SA} - \\filemodprintdate{\"" + filepath + "\"}}}, % Copyright information\n"

    copyrightsimbol = "cr="
    lineofcopyright = -1
    for line in range(lineofoptionsstart, lineofoptionsstop):
        if lineofcopyright == -1:
            indexofcr = filetolines[line].find(copyrightsimbol)
            if indexofcr != -1:
                lineofcopyright = line
                break
    if lineofcopyright != -1:
        print("last copyright \"" + filetolines[lineofcopyright] + "\"")
        filetolines[lineofcopyright] = copyright
        print("updated copyright \"" + filetolines[lineofcopyright] + "\"")
        updates = ''.join(filetolines)
        print(updates)
        with open(filepath, "r+") as f:
            f.write(updates)
            f.truncate()
            f.close()
    else:
        print("No copyright found for \"" + filepath + "\"")

    #file.write()

    # Closes the song file
    file.close()

# Generates the pdfs of the book
def booksgenerator():
    subprocess.run(["sh", "GuitarHubGenerator.sh"])

# If not the directory where building the book then exit
last_dir = "src"
if(currentdirectorycheck(last_dir) is not True):
    # Not the right working directory
    exit("You are not working in the \"" + last_dir
        + "\" directory contained to the GuitarHub directory.\n"
        + "Firstly change the working directory "
        + "and then lanch the generator.")
else:
    # Saves the current working directory
    current_working_directory = os.getcwd()
    print("Working directory: \"" + current_working_directory + "\"")

for root, dirs, files in os.walk(os.getcwd() + "/tex/"):
    indexofsrc = root.find(last_dir)
    for file in files:
        relativepath = root[indexofsrc + len(last_dir) + 1:] + "/" + file
        updatesongcopyright(relativepath)

booksgenerator()
