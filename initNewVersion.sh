#!/bin/bash

export masterLProj="English.lproj"

if [ $# != 2 ] ; then
	echo "Usage: ./initNewVersion.sh old_versino_number new_version_number"
else
	export oldVer=$1
	export newVer=$2
	
	if [ -d $oldVer ] ; then
		# oldVe必须存在
		
		if [ -d ../MPlayerX/$masterLProj ] ; then
			# ../MPlayerX/$masterLProj 也必须存在
			
			if [ -d $newVer ] ; then
				echo "$newVer already exists"
				
				export oldVer=$2
				export newVer="../MPlayerX/$masterLProj"
				
				echo "Updating from $oldVer -> $newVer"
				
				find $newVer -not -name *.lproj | while read filePath
				do
					# 遍历MPlayerX里面所有的文件
					fileName=`basename $filePath`
					ext=${fileName##*.}
					fileNameNoExt=${fileName%.*}
					
					if [ -f $oldVer/$masterLProj/$fileName ] ; then
						# 如果对应的旧文件夹里面有同样的文件的话
						
						# 两个文件比较
						diffRes=`diff $filePath ./$oldVer/$masterLProj/$fileName | wc -l`
						
						if [ $diffRes == 0 ] ; then
							# 两个文件相同的话，什么也不做
							echo "Same File: $filePath and $oldVer/$masterLProj/$fileName"
						else
							# 两个文件不同的话，根据文件的不同更新
							echo "DIFF File: $filePath and $oldVer/$masterLProj/$fileName"
							
							if [ $ext == "xib" ] ; then
								# 如果是xib文件，那么需要特殊的命令
								
								find $oldVer -name *.lproj -and -not -name $masterLProj | while read folderPath
								do
									# 寻找旧文件夹里面所有的【翻译版本】
									echo "ibtool --previous-file ./$oldVer/$masterLProj/$fileName --incremental-file ./$folderPath/$fileName --localize-incremental --write ./$folderPath/$fileNameNoExt.updated.$ext $filePath"
								done
							else
								# 如果是普通文件的话，直接拷贝
								
								find $oldVer -name *.lproj -and -not -name $masterLProj | while read folderPath
								do
									# 寻找旧文件夹里面所有的【翻译版本】
									echo "cp -R $filePath ./$folderPath/$fileNameNoExt.updated.$ext"
								done
							fi
							
							# 然后将【Master版本】拷贝
							echo "cp -R $filePath $oldVer/$masterLProj/$fileName"
						fi
					else
						# 如果旧文件夹里面没有该文件的话，说明是新文件，那么就更新
						find $oldVer -name *.lproj -and -not -name $masterLProj | while read folderPath
						do
							echo "cp -R $filePath ./$folderPath/$fileNameNoExt.newfish.$ext"
						done
					fi
				done

			else
				# 如果目标新文件夹不存在的话，说明是全新的更新
				echo "$oldVer -> $newVer, Start initialization..."
				
				# 创建新文件夹
				mkdir -p $newVer
				
				# 将现在MPlayerX里面的文件夹全部拷贝
				cp -R ../MPlayerX/$masterLProj $newVer/
				
				# 拷贝 Makefile
				cp template.Makefile $newVer/Makefile
				
				find $oldVer -name *.lproj -and -not -name $masterLProj | while read folderPath
				do
					# 旧文件夹里面所有的【翻译版本】
					echo $folderPath
					
					# 【翻译版本】文件夹的名字
					folderName=`basename $folderPath`
					
					# 创建相应新版本的【翻译版本】文件夹
					mkdir -p $newVer/$folderName

					find $folderPath -not -name *.lproj | while read filePath
					do
						# 对于所有的文件
						fileName=`basename $filePath`
						ext=${fileName##*.}
						fileNameNoExt=${fileName%.*}
						
						if [ $ext == "xib" ] ; then
						
							if [ -f ./$oldVer/$masterLProj/$fileName ] && [ -f ./$filePath ] && [ -f ./$newVer/$masterLProj/$fileName ] ; then
								# 对于xib文件，命令不一样
								echo "ibtool --previous-file ./$oldVer/$masterLProj/$fileName --incremental-file ./$filePath --localize-incremental --write ./$newVer/$folderName/$fileName ./$newVer/$masterLProj/$fileName"
							else
								echo "necessary files are missing for xib transformation"
							fi
						else
							# 如果是其他文件，既拷贝旧【翻译版本】，也拷贝新【Master版本】
							echo "cp ./$filePath ./$newVer/$folderName/$fileNameNoExt.prev.$ext"
							echo "cp ./$newVer/$masterLProj/$fileName ./$newVer/$folderName/$fileNameNoExt.now.$ext"
						fi
					done
				done
				
				# check if there are new things
				find $newVer/$masterLProj -not -name *.lproj | while read newFilePath
				do
					# 遍历新【Master版本】
					newFileName=`basename $newFilePath`
					ext=${newFileName##*.}
					fileNameNoExt=${newFileName%.*}

					if [ -e $oldVer/$masterLProj/$newFileName ] ; then
						echo "$oldVer/$masterLProj/$newFileName already exist"
					else
						find $newVer -name *.lproj -and -not -name $masterLProj | while read folderPath
						do
							# 新出现的文件就拷贝
							echo "cp -R ./$newFilePath ./$folderPath/$fileNameNoExt.newfish.$ext"
						done
					fi
				done
			fi
		else
			echo "folder structure misses ../MPlayerX/"
		fi
	else
		echo "$oldVer doesn’t exists"
	fi
	
fi