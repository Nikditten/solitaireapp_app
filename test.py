import requests

url = 'http://192.168.137.253:8000/analyze_image'

with open('/Users/niklas/Pictures/black_unity_22_wallpaper_mac.png', 'rb') as file:
    response = requests.post(url, files={'file': file})
    print(file)
    print(response.status_code)
