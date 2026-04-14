import json
import sys

data = json.load(open(sys.argv[1]))
p = data["recommended_params"]

cmd = f"--soloCBstart {p['soloCBstart']} " \
      f"--soloCBlen {p['soloCBlen']} " \
      f"--soloUMIstart {p['soloUMIstart']} " \
      f"--soloUMIlen {p['soloUMIlen']} " \
      f"--soloBarcodeReadLength 0 " \
      f"--soloCBwhitelist None"

print(cmd)