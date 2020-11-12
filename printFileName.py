import os
dirName = 'assets/images/'
fileDir = '4.0x/'
for filename in os.listdir(r'%s/%s' % (dirName,fileDir)):
	print '- %s/%s%s' % (dirName,fileDir,filename)