import requests
# find and save the current Github release
html = str(
           requests.get('https://github.com/Masterminds/glide/releases/latest')
           .content)
index = html.find('Release Release ')
github_version = html[index + 16:index + 22]
file = open('github_version.txt', 'w')
file.writelines(github_version)
file.close()

# find and save the current version on FTP server
html = str(
           requests.get(
                        'https://oplab9.parqtec.unicamp.br/pub/ppc64el/glide'
                        ).content)
index = html.rfind('glide-')
ftp_version = html[index + 6:index + 12]
file = open('ftp_version.txt', 'w')
file.writelines(ftp_version)
file.close()

# find and save the oldest version on FTP server
index = html.find('glide-')
delete = html[index + 6:index + 12]
file = open('delete_version.txt', 'w')
file.writelines(delete)
file.close()
