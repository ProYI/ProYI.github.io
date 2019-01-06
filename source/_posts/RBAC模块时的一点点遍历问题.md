---
title: RBAC模块时的一点点遍历问题
tags:
  - RBAC
  - 遍历， 递归
categories:
  - 技术
  - Java
  - Java web
abbrlink: a831b05
date: 2019-01-06 22:27:51
permalink:
description:
image:
copyright:
sticky:
---
<p class="description">权限管理模块时的一点点遍历问题记录</p>
<!-- more -->
基于角色的权限访问控制（Role-Based Access Control）是一种经典的权限管理模型，在项目中经常使用。  

在做此模块的时候，因为涉及到了权限的存储问题，所以表的设计是` id name parent_id`的存储模式。因此我们可以将这种结构看成树形结构，通过父子节点的连接来确定位置。  

我们可以通过ArrayList将所有的父子节点存储起来，传到前端供其使用  

可是如果子节点下还有分支，就需要添加List，并将孙节点信息存储。因为`父节点`-`子节点`-`孙节点`的结构是相同的，只是所属层级不同，我们就想到了使用递归算法来遍历获取。  


这样似乎可以完美解决了分支的动态增删，可是<span style="border-bottom:2px dashed red;">如果考虑到数据库性能是否可行？</span>  

每次遍历一层节点都需要查询一次数据库，多层查询就需要多少次数据库查询，这样对数据库资源是一种浪费  

因此先将所有数据`一次性查询`出来，然后再在代码中进行逻辑处理，更为合理  

特此记录  

## 递归获取树形结构内容  
```java
Set<Category> categorySet = Sets.newHashSet();
findChildCategory(categorySet, categoryId);

private Set<Category> findChildCategory(Set<Category> categorySet, Integer categoryId) {
    Category category = categoryMapper.selectByPrimaryKey(categoryId);
    if (category != null) {
        categorySet.add(category);
    }
    //查找子节点，递归算法一定要有一个退出条件
    List<Category> categoryList = categoryMapper.selectCategoryChildrenByParentId(categoryId);
    for (Category categoryItem : categoryList) {
        findChildCategory(categorySet, categoryItem.getId());
    }
    return categorySet;
}
```
## 嵌套for循环获取树形结构  
```java 
    List<Permission> permissions = new ArrayList<Permission>();
    // 查询所有的权限permission
    List<Permission> ps = permissionService.queryAll();
    
    for (Permission : ps) {
        // 子节点 
        Permission child = p;
        if (p.getPid() == 0) {
            // 顶级节点
            permission.add(p);
        } else {
            for (permission innerPermission : ps) {
                if (child.getPid().equals(innerPermission.getId())) {
                    // 父节点
                    Permission parent = innerPermission;
                    // 组合父子节点的关系
                    parent.getChildren().add(child);
                }
            }
        }
    }
    return permission;
```
## 使用Map获取  
使用map就可以使用到索引进行查询，所以效率比仅用for循环更高
```java
    List<Permission> permissions = new ArrayList<Permission>();
    // 查询所有的权限permission
    List<Permission> ps = permissionService.queryAll();

    Map<Integer, Permission> permissionMap = new HashMap<Integer, Permission>();
    for (Permission p : ps) {
        permissionMap.put(p.getId(), p);
    }

    for (Permission p : ps) {
        Permission child = p;
        if (child.getPid() == 0) {
            Permissions.add(p)
        } else {
            Permission parent = permissionMap.get(child.getPid());
            parent.getChildren().add(child);
        }
    }
    return permission;
```
<hr />