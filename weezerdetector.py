#!/usr/bin/env python3
from PIL import Image, ImageColor
from bs4 import BeautifulSoup
import requests

# Step 1: Figure out what all the weezer blues are
weezer_blues_hex = [0x189bcc] # The default value, if all else fails

try:
	resp = requests.get("https://colornames.org/search/results/?type=exact&query=Weezer+Blue");
	soup = BeautifulSoup(resp.text)
	[weezer_blues_hex.append(int(link.get('style').split(':#')[1], 16)) for link in soup.select("a.freshButton")]; #Is this futureproof? Who knows!
	weezer_blues_hex = weezer_blues_hex[1:]; #remove the default
except requests.exceptions.RequestException:
	print("colornames.org refuses to cooperate with us, so we'll just use the default weezer blue I guess :/");
	
# Step 2: I don't feel like describing just read
weezer_blues = [ImageColor.getcolor(f"#{weezer_blue:06x}", "RGB") for weezer_blue in weezer_blues_hex]

# Step 3: Weeze
from sys import argv
if(len(argv)>1):
	try:
		img = Image.open(argv[1]);
	except FileNotFoundError:
		print(f"{argv[1]} doesn't exist >:(");
		from os import execl
		execl(argv[0], argv[0]); #Restart but try maybe-weezer.jpg
else:
	try:
		img = Image.open("maybe-weezer.jpg");
	except FileNotFoundError:
		print(f"maybe-weezer.jpg doesn't exist >:(. How do you expect me to find the weezer in a file that doesn't exist gosh darn it");
		raise FileNotFoundError("Fuck you")
		

(width, height) = img.size;

for weezer_blue in weezer_blues:
	found_something_for_this_colour = False
	for x in range(width):
		for y in range(height):
			px = img.getpixel((x, y));
			if px==weezer_blue:
				print(f"FOUND WEEZER BLUE (i.e. #{weezer_blue[0]*256*256 + weezer_blue[1]*256 + weezer_blue[2]:06x}) AT {(x, y)}!!!!!");
				found_something_for_this_colour = True;
	print(f"No{' more' if found_something_for_this_colour else 'ne'} of the #{weezer_blue[0]*256*256 + weezer_blue[1]*256 + weezer_blue[2]:06x} Weezer Blue :(");
