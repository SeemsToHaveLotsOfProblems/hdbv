extends RichTextLabel

# Place my credits here, and the system will add them into the credit screen.
var credits: PackedStringArray = [
	"Programming & Game Design by:\n\t[color=purple]Fatal Error Drive B[/color]"
]

var third_party_license: PackedStringArray = [
	"mbed TLS\n\tCopyright The Mbed TLS Contributors\n\tLicensed under the Apache License, Version 2.0 (the \"License\"); you may not use this file except in compliance with the License. You may obtain a copy of the License at\n\thttp://www.apache.org/licenses/LICENSE-2.0\n\tUnless required by applicable law or agreed to in writing, software distributed under the License is distributed on an \"AS IS\" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.\n\n",
	"ENet\n\tCopyright (c) 2002-2020 Lee Salzman\n\t\tPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\t\t\tThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\t\t\tTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n\n",
	"FreeType\n\tPortions of this software are copyright © <1996-2023> The FreeType Project (www.freetype.org). All rights reserved."
]

# Displays the credits needed by the godot engine
func _ready() -> void:
	build_credits()


func build_credits() -> void:
	text = ""
	for i in credits:
		text += i + "\n"
	text += "\n"
	text += Engine.get_license_text() + "\n\n"
	
	for i in third_party_license:
		text += i
