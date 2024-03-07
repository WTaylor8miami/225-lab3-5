FROM python:3.8

# Install dependencies for Chrome
RUN apt-get update && apt-get install -y wget unzip curl gnupg

# Add Google Chrome repository
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list

# Install Chrome
RUN apt-get update && apt-get install -y google-chrome-stable

# Automatically determine the most recent compatible ChromeDriver version and install it

RUN CHROME_VERSION=$(google-chrome --version | grep -oE "[0-9]+" | head -1) 
RUN CHROMEDRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION") 
RUN wget -N "http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip" -P /tmp 
RUN unzip /tmp/chromedriver_linux64.zip -d /usr/local/bin/
RUN chmod +x /usr/local/bin/chromedriver && rm /tmp/chromedriver_linux64.zip

# Install Selenium
RUN pip install selenium

# Your remaining setup (e.g., copying files into the container)


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
