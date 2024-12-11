import subprocess

def run_recover_script(disk, out_dir, pattern, mode):
    print("Running recover.sh script...")
    command = ["sudo", "./recover.sh", disk, out_dir,pattern, mode]
    print(command)
    subprocess.run(command)
# run_recover_script()