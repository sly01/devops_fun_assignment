import unittest
from main import index
class TestFunctionHello1(unittest.TestCase):
    def test_return_content_successfull(self):
        self.assertTrue(index('','')['statusCode'] is 200 and "Hello World 2!" in index('','')['body'])