## application.propertise
```properties
spring.servlet.multipart.enabled=true
# It specifies the maximum size permitted for uploaded files. The default is 1MB.
spring.servlet.multipart.max-file-size=10MB
# It specifies the maximum size allowed for multipart/form-data requests. The default is 10MB.
spring.servlet.multipart.max-request-size=15MB
```
## uploader-controller
```java
@PostMapping("/upload")
public ResponseEntity uploadToLocalFileSystem(@RequestParam("file") MultipartFile file) {
	String fileName = StringUtils.cleanPath(file.getOriginalFilename());
	Path path = Paths.get(fileBasePath + fileName);
	try {
		Files.copy(file.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);
	} catch (IOException e) {
		e.printStackTrace();
	}
	String fileDownloadUri = ServletUriComponentsBuilder.fromCurrentContextPath()
			.path("/files/download/")
			.path(fileName)
			.toUriString();
	return ResponseEntity.ok(fileDownloadUri);
}

@PostMapping("/multi-upload")
public ResponseEntity multiUpload(@RequestParam("files") MultipartFile[] files) {
	List<Object> fileDownloadUrls = new ArrayList<>();
	Arrays.asList(files)
			.stream()
			.forEach(file -> fileDownloadUrls.add(uploadToLocalFileSystem(file).getBody()));
	return ResponseEntity.ok(fileDownloadUrls);
}
```
## downloader-controller
```java
@GetMapping("/download/{fileName:.+}")
public ResponseEntity downloadFileFromLocal(@PathVariable String fileName) {
	Path path = Paths.get(fileBasePath + fileName);
	Resource resource = null;
	try {
		resource = new UrlResource(path.toUri());
	} catch (MalformedURLException e) {
		e.printStackTrace();
	}
	return ResponseEntity.ok()
			.contentType(MediaType.parseMediaType(contentType))
			.header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + resource.getFilename() + "\"")
			.body(resource);
```

## db-pojo
```java
@Entity
public class Document {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column
    private String docName;

    @Column
    @Lob
    private byte[] file;
}
```

## db-uploader-controller
```java
@PostMapping("/upload/db")
public ResponseEntity uploadToDB(@RequestParam("file") MultipartFile file) {
	Document doc = new Document();
	String fileName = StringUtils.cleanPath(file.getOriginalFilename());
	doc.setDocName(fileName);
	try {
		doc.setFile(file.getBytes());
	} catch (IOException e) {
		e.printStackTrace();
	}
	documentDao.save(doc);
	String fileDownloadUri = ServletUriComponentsBuilder.fromCurrentContextPath()
			.path("/files/download/")
			.path(fileName).path("/db")
			.toUriString();
	return ResponseEntity.ok(fileDownloadUri);
}
```
## db-downloader-conroller
```java
@GetMapping("/download/{fileName:.+}")
public ResponseEntity downloadFileFromLocal(@PathVariable String fileName) {
	Path path = Paths.get(fileBasePath + fileName);
	Resource resource = null;
	try {
		resource = new UrlResource(path.toUri());
	} catch (MalformedURLException e) {
		e.printStackTrace();
	}
	return ResponseEntity.ok()
			.contentType(MediaType.parseMediaType(contentType))
			.header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + resource.getFilename() + "\"")
			.body(resource);
```


