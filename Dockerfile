FROM python:3.8

# Install necessary packages for Chrome and wget
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    nginx

# Install Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt install ./google-chrome-stable_current_amd64.deb -y

# Install ChromeDriver
RUN CHROME_VERSION=$(google-chrome --version | grep -oE "[0-9]+.[0-9]+.[0-9]+.[0-9]+") && \
    wget -N http://chromedriver.storage.googleapis.com/$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION)chromedriver_linux64.zip -P ~/ && \
    unzip ~/chromedriver_linux64.zip -d ~/ && \
    mv -f ~/chromedriver /usr/local/bin/chromedriver && \
    chmod +x /usr/local/bin/chromedriver && \
    rm ~/chromedriver_linux64.zip

# Install Selenium
RUN pip install selenium

# Copy your web content and configuration into the container
WORKDIR /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/index.html
COPY style.css /usr/share/nginx/html/style.css
# Add this line to clear errors with robots.txt
COPY robots.txt /usr/share/nginx/html/robots.txt

# Copy the script to start Nginx and run tests
COPY start_services_and_tests.sh /usr/local/bin/start_services_and_tests.sh
RUN chmod +x /usr/local/bin/start_services_and_tests.sh

# The command to run when the container starts
CMD ["/usr/local/bin/start_services_and_tests.sh"]
