package de.herhold.helloservice.controller;

import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.client.builder.AwsClientBuilder;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.Bucket;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class HelloController {
    @Value("${app.access:foobar}")
    private String accessKey;
    @Value("${app.secret:foobar}")
    private String secret;
    //@Value("${app.endpoint}")
    private String endpoint = "http://localstack.local";

    @GetMapping(value = "/hello")
    public ResponseEntity<String> sayHallo() {
        return new ResponseEntity<>("Hello, World!", HttpStatus.OK);
    }

    @GetMapping(value = "/s3")
    public ResponseEntity<String> s3Test() {
        AWSCredentials credentials = new BasicAWSCredentials(
                accessKey,
                secret
        );
        System.out.println(endpoint);
        System.out.println("New Version");
        AmazonS3 s3client = AmazonS3ClientBuilder
                .standard()
                .withCredentials(new AWSStaticCredentialsProvider(credentials))
                .withEndpointConfiguration(new AwsClientBuilder.EndpointConfiguration(endpoint, "eu-central-1"))
                .build();
        String bucketName = "test";

        if (s3client.doesBucketExist(bucketName)) {
            System.out.println("Bucket name is not available."
                    + " Try again with a different Bucket name.");
        } else {
            s3client.createBucket(bucketName);
        }

        s3client.putObject(bucketName, "test.txt", "this is a test");


        List<com.amazonaws.services.s3.model.Bucket> buckets = s3client.listBuckets();
        for (Bucket bucket : buckets) {
            System.out.println(bucket.getName());
        }
        return new ResponseEntity<>("NICE", HttpStatus.OK);
    }
}
