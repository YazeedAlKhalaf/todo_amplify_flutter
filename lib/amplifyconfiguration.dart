const amplifyconfig = ''' {
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "us-east-2:6788446c-4040-4743-a6c9-e5f814d3bee0",
                            "Region": "us-east-2"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "us-east-2_5aFCdF4kb",
                        "AppClientId": "6hdqs26d95j2filt9vp0enbbkv",
                        "Region": "us-east-2"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH"
                    }
                },
                "AppSync": {
                    "Default": {
                        "ApiUrl": "https://nf2inwefajc63ggaienacn4bdi.appsync-api.us-east-2.amazonaws.com/graphql",
                        "Region": "us-east-2",
                        "AuthMode": "API_KEY",
                        "ApiKey": "da2-j57nbnyc3fhsjfdofkb3kc4c4q",
                        "ClientDatabasePrefix": "todoamplify_API_KEY"
                    },
                    "todoamplify_AWS_IAM": {
                        "ApiUrl": "https://nf2inwefajc63ggaienacn4bdi.appsync-api.us-east-2.amazonaws.com/graphql",
                        "Region": "us-east-2",
                        "AuthMode": "AWS_IAM",
                        "ClientDatabasePrefix": "todoamplify_AWS_IAM"
                    }
                }
            }
        }
    },
    "api": {
        "plugins": {
            "awsAPIPlugin": {
                "todoamplify": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://nf2inwefajc63ggaienacn4bdi.appsync-api.us-east-2.amazonaws.com/graphql",
                    "region": "us-east-2",
                    "authorizationType": "API_KEY",
                    "apiKey": "da2-j57nbnyc3fhsjfdofkb3kc4c4q"
                }
            }
        }
    }
}''';