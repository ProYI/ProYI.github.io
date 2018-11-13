---
title: javaweb项目中的git初始化.md
tags:  
  - java web
  - git初始化
date: 2018-11-12 23:06:55
permalink:
categories:  
  - 技术
  - Java
  - Java web
description:
copyright:
sticky:
---
<p class="description">关于java web项目中git初始化的一些内容记录</p>
<!-- more -->

## 创建README.md
新建项目后，在项目目录下新建README.md文件。可以使用右键创建，也可以使用命令行创建
```
touch README.md 

type nul > README.md //windows命令行命令
```
ps: `echo > 文件名`此命令创建的文件应该是由于windows平台的编码及其文本格式的问题，打开后提示不是UTF-8的编码格式，并且空文件中也有一些乱码内容  

## 创建.gitignore
如果项目中没有.gitignore文件，可以使用上面的命令新建此文件，次文件中可以配置一些相匹配的文件，使某些匹配的文件不要上传的git版本控制服务器中  
一般springboot项目中就已经有这个项目，只需要编写里面的内容就可以了  
```
*.class

#package file
*.war
*.ear

#kdiff3 ignore
*.orig

#maven ignore
/target/
!.mvn/wrapper/maven-wrapper.jar

#eclopse ignore
.settings/
.project
.classpatch

### STS ###
.apt_generated
.classpath
.factorypath
.project
.settings
.springBeans
.sts4-cache

### IntelliJ IDEA ###
.idea
/idea/
*.iws
*.iml
*.ipr

### NetBeans ###
/nbproject/private/
/build/
/nbbuild/
/dist/
/nbdist/
/.nb-gradle/

#temp file
*.log
*.cache
*.diff
*.patch
*.tmp

#system ignore
.DS_Store
Thumbs.db
```
## git初始化
在IDEA命令行中初始化git仓库
```
git init
git status
git add .
git commit -am 'first commit init project'
git remote add origin git的地址 //将本地仓库添加到远程仓库
git  branch //查看分支
git push -u origin master //推送到远端

如果远程和本地库有冲突，需要先执行
git pull 
git push -u -f origin master //强制 推送到远端

git checkout -b 分支名 origin/master //在master的基础上创建新分支

git push origin HEAD -u //将分支push到远端库
```
<hr />