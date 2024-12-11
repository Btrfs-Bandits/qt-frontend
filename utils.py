import subprocess

def run_recover_script(disk, out_dir, pattern, mode):
    print("Running recover.sh script...")
    command = ["sudo", "./recover.sh", "/dev/nvme0n1p8", "/home/himesh/recovered", ".*", "recover"]
    subprocess.run(command)
# run_recover_script()