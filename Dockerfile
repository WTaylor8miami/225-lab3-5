FROM python:3.8

# Install Chrome
RUN apt-get update && apt-get install -y wget gnupg2 unzip
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt install ./google-chrome-stable_current_amd64.deb -y

# Install ChromeDriver
RUN wget https://chromedriver.storage.googleapis.com/2.41/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip
RUN mv chromedriver /usr/bin/chromedriver
RUN chmod +x /usr/bin/chromedriver

# Install Selenium
RUN pip install selenium

# Copy your test script into the container
WORKDIR /tests
COPY requirements.txt .
COPY default.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/index.html
COPY style.css /usr/share/nginx/html/style.css

#add this line to clear errors with robots.txt
COPY robots.txt /usr/share/nginx/html/robots.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY tests/ .
CMD ["python", "test_html_elements.py]
