import unittest
from selenium import webdriver
from selenium.webdriver.common.by import By

class HtmlElementsTestCase(unittest.TestCase):
    def setUp(self):
        # Options for running Chrome headless
        options = webdriver.ChromeOptions()
        options.add_argument('--headless')  # Correct argument
        # Initialize the driver with options
        self.driver = webdriver.Chrome(options=options)  # Use options here

    def test_html_elements(self):
        # Use self.driver directly
        self.driver.get("http://10.48.10.153:32000")  # Change this to your IP
        # Example test: Uncomment and adapt as needed
        # Check for the presence of a specific HTML element by ID
        # some_element = self.driver.find_element(By.ID, "someElementId")
        # self.assertIsNotNone(some_element)
        
    def tearDown(self):
        self.driver.quit()

if __name__ == "__main__":
    unittest.main()
