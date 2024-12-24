application
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/test
spring.datasource.username=root
spring.datasource.password=root
spring.jpa.show-sql=true
spring.jpa.hibernate.ddl-auto=create-drop
spring.user.datasource.driver-class-name=com.mysql.jdbc.Driver
spring.jpa.hibernate.naming.physical-strategy=org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl
```

## Auto 
```java
@EnableJpaAuditing
Main

@EntityListeners(value = [AuditingEntityListener::class])
public class Entity{
	@CreatedDate  
	@Column(name = "created_date", nullable = false, updatable = false)
	String created_time
}
```

## Annotation
![](/recap/server/attachments/Pastedimage20230710174459.png)
![](/recap/server/attachments/Pastedimage20230710174528.png)

## jpa关键字
![](/recap/server/attachments/Pastedimage20230710174642.png)
![](/recap/server/attachments/Pastedimage20230710174701.png)
## enum
```java
@Enumerated(value = EnumType.ORDINAL)
```

## 分页
```kotlin
@PostMapping("all")  
fun all(page: Int, size: Int): SaResult{  
	return goodsRepository.findAll(PageRequest.of(page - 1, size))
}
```

## Http request
```http
POST http://localhost:8080/api/upload?md5code=77963b7a931377ad4ab5ad6a9cd718aa&college=jy  
Content-Type: multipart/form-data; boundary=WebAppBoundary  
  
--WebAppBoundary  
Content-Disposition: form-data; name="file"; filename="dd.txt"  
  
< D:\Suanxc\dd.txt  
--WebAppBoundary--
```
