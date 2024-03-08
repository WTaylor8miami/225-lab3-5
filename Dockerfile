FROM ubuntu

# Install dependencies for Chrome
RUN apt-get update && apt-get install -y wget unzip curl gnupg

# Add Google Chrome repository
RUN apt-get update && apt-get install -y wget gnupg2 unzip
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt install ./google-chrome-stable_current_amd64.deb -y

# Install Chromedriver
RUN wget -N "https://storage.googleapis.com/chrome-for-testing-public/122.0.6261.111/linux64/chromedriver-linux64.zip" -P /tmp 
RUN unzip /tmp/chromedriver-linux64.zip -d /usr/local/bin/
RUN chmod +x /usr/local/bin/chromedriver-linux64 

# Install Selenium
RUN apt-get install pip -y
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
