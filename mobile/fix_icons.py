import re

with open("lib/app/modules/calendar/views/calendar_view.dart", "r") as f:
    lines = f.readlines()

def replace_icon(line_num, icon_str):
    idx = line_num - 1
    # Match trailing whitespace and brackets
    indent = len(lines[idx]) - len(lines[idx].lstrip())
    lines[idx] = " " * indent + f"children: [{icon_str}],\n"

replace_icon(540, "const Icon(Icons.wb_sunny_outlined, color: Color(0xFFBBF246), size: 24)")
replace_icon(636, "const Icon(Icons.check_circle, color: Color(0xFF8C8B90), size: 24)")
replace_icon(822, "const Icon(Icons.medication_outlined, color: Color(0xFF1C1B1C), size: 24)")
replace_icon(997, "const Icon(Icons.directions_walk, color: Color(0xFF1C1B1C), size: 24)")
replace_icon(1153, "const Icon(Icons.wb_sunny_outlined, color: Color(0xFFBBF246), size: 24)")
replace_icon(1246, "const Icon(Icons.restaurant, color: Color(0xFF1C1B1C), size: 24)")
replace_icon(1421, "const Icon(Icons.people_alt_outlined, color: Color(0xFF1C1B1C), size: 24)")
replace_icon(1577, "const Icon(Icons.nightlight_round_outlined, color: Color(0xFFBBF246), size: 24)")
replace_icon(1670, "const Icon(Icons.dark_mode_outlined, color: Color(0xFF1C1B1C), size: 24)")

with open("lib/app/modules/calendar/views/calendar_view.dart", "w") as f:
    f.writelines(lines)
