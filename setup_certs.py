import os
import subprocess
import sys
from pathlib import Path

def check_mkcert_installed():
    """Check if mkcert is available in the system."""
    try:
        subprocess.run(['mkcert', '-version'], capture_output=True)
        return True
    except FileNotFoundError:
        return False

def install_mkcert_instructions():
    """Print instructions for installing mkcert."""
    print("\nMkcert is not installed. Please install it first:")
    print("\nWindows (using Chocolatey):")
    print("    choco install mkcert")
    print("\nWindows (manual):")
    print("    1. Download from https://github.com/FiloSottile/mkcert/releases")
    print("    2. Add the executable to your PATH")
    print("\nAfter installing, run this script again.")
    sys.exit(1)

def setup_certificates():
    """Generate local certificates using mkcert."""
    print("\n=== Setting up HTTPS Certificates ===")
    
    # Check for mkcert
    if not check_mkcert_installed():
        install_mkcert_instructions()

    # Create certs directory if it doesn't exist
    certs_dir = Path('certs')
    certs_dir.mkdir(exist_ok=True)
    
    try:
        # Install local CA
        print("\nInstalling local Certificate Authority...")
        subprocess.run(['mkcert', '-install'], check=True)
        
        # Generate certificates
        print("\nGenerating certificates for localhost and local IP...")
        subprocess.run([
            'mkcert',
            '-key-file', str(certs_dir / 'localhost-key.pem'),
            '-cert-file', str(certs_dir / 'localhost.pem'),
            'localhost',
            '127.0.0.1',
            '192.168.0.16'  # Add your local IP here
        ], check=True)
        
        # Update Flask config
        print("\nUpdating Flask configuration...")
        with open('hub/main.py', 'r') as f:
            lines = f.readlines()
        
        # Find and update the ssl_context line
        for i, line in enumerate(lines):
            if 'ssl_context' in line:
                lines[i] = "    ssl_context = ('certs/localhost.pem', 'certs/localhost-key.pem')\n"
                break
        
        with open('hub/main.py', 'w') as f:
            f.writelines(lines)
        
        # Update .gitignore to exclude certs directory
        gitignore_path = Path('.gitignore')
        if gitignore_path.exists():
            with open(gitignore_path, 'r') as f:
                content = f.read()
            if 'certs/' not in content:
                with open(gitignore_path, 'a') as f:
                    f.write('\n# Certificate directory\ncerts/\n')
        
        print("\n✅ Certificate setup complete!")
        print("\nCertificates are stored in the 'certs' directory:")
        print("  - certs/localhost.pem")
        print("  - certs/localhost-key.pem")
        print("\nThese files are automatically ignored by git.")
        
    except subprocess.CalledProcessError as e:
        print(f"\n❌ Error during certificate setup: {e}")
        sys.exit(1)

if __name__ == '__main__':
    setup_certificates()