const String http = 'http';
const String https = 'https';
const List<String> protocols = [http, https];

// as milliseconds
const int connectionTimeout = 10000;
// as milliseconds
const int receiveTimeout = 3000;
const contentType = 'application/json';

const apiPathAuthRegistration = '/auth/registration/';
const apiPathAuthResetPassword = '/auth/reset-password/';
