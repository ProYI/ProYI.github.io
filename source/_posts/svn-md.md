---
title: 版本控制工具之SVN学习
tags:
  - svn
  - 版本控制
categories:
  - 技术
  - 工具
abbrlink: 906bd7c
date: 2018-11-04 14:25:10
permalink:
description:
copyright:
sticky:
---
<p class="description">学习新的一种代码版本控制工具--SVN，以前也听说过，只是一直没有机会用，所以学习一下吧</p>

<!-- more -->

## 前言
以前自己学习的时候，因为要push到GitHub，所以了解了下Git的用法和一些命令，外加IDE对Git的支持挺好的，就没有在本地建过版本控制。现在要进入新公司实习，听说要使用SVN来进行版本管理，所以提前学习一下。想来版本工具也是万变不离其宗的，应该不会有太大问题。    
## SVN的下载与安装
SVN的安装分为服务端和客户端，此处以windows版本为例  
SVN Service：下载地址 [https://www.visualsvn.com/server/download/](https://www.visualsvn.com/server/download/)  
SVN Client: 下载地址 [https://tortoisesvn.net/](https://tortoisesvn.net/)  
先安装服务端再安装客户端，Windows安装过程比较简单，根据自身需要选择安装地址即可  
## 服务端配置
1. 启动visual svn的可视化管理界面，在Repositories文件夹上右键即可新建一个仓库。可以选择用户权限、访问端口、是否使用Https等等  
    设置成功后显示  
    ```
    Repository type:FSFS  (默认，自行选择)
    Repository name:Test  (自定义)
    Repository URL:https://127.0.0.1:8443/svn/Test  (客户端和服务端通信地址)
    ```
2. 在Users文件夹上右键新建使用用户。因为在建立仓库时已经选择了用户是否具有`读/写`权限，所以建立用户时不需要设置
## 客户端连接服务端
1. 在需要拉去服务端内容的文件夹内右键-->svn checkout  
    ```
    URL of repository : 仓库的URL
    Checkout directory : 本地文件存储的位置
    ```
2. 输入分配给的User的登录名和密码  
3. 在你本地的文件夹就拉取服务端内容，并存在一个隐藏文件夹`.svn`  
## SVN的基本操作
1. 本地文件夹中新建一个文件，在该文件夹下就可以右键`svn commit`，选择你需要提交的版本库中的文件提交即可  
2. 删除本地后需要同时删除服务端的文件，只需要再次选中并提交即可  
## SVN常见问题  
1. 多人操作同一文件时经常会发生冲突，在文件行数不冲突的情况下SVN可以自动合并（Marg）  
2.  如果是修改同一行文件，且某一人先提交一次，在你自己提交时是由上一个版本提交的，内容和服务端最新版本不符，SVN并不能确定，会导致错误，文件标志也会显示感叹号，需要和上次修改的作者进行沟通，自行处理保留哪个版本  
3. 一般提交前，需要先使用`SVN update`保证当前版本最新，再进行提交  
4. 如果发现版本冲突，想要知道哪些冲突。先备份自己修改的代码，然后在修改代码文件上右键`TortoiseSVN`-->`Revert`恢复成自己上次从服务端获取的代码，然后再使用`SVN update`更新，最后选中最新代码的文件和自己备份的修改后的文件，右键`TortoiseSVN`-->`Diff`使用SVN的比对工具查看哪些地方冲突，以解决问题  
5. 如果某块代码被其他修改后，并未出错，提交多次后原作者发现修改内容与之前不符，并导致程序bug，如何查找？  
    右键`TortoiseSVN`-->`show log`，选中最近的两次提交右键-->`Compare revisions`逐个版本进行比对，直至找到修改的作者，再进行讨论
## SVN分支控制
待续
<hr />