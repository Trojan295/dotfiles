# Python environment

1. Install `pipenv`
   ```bash
   sudo apt-get install -y pipenv
   ```

2. Setup pyenv and pyenv-virtualenv
   ```bash
   curl https://pyenv.run | bash
   ```

3. Install dependencies to install Python versions
   ```bash
   sudo apt-get install -y libbz2-dev libreadline-dev libssl-dev
   ```

4. Install Python version
   ```bash
   PYTHON_VERSION="3.9.7"
   pyenv install "${PYTHON_VERSION}"
   ```
