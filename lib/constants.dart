const String http = 'http';
const String https = 'https';
const List<String> protocols = [http, https];

// as milliseconds
const int connectionTimeout = 10000;
// as milliseconds
const int receiveTimeout = 3000;
const contentType = 'application/json';

const apiResponseMessageKey = 'detail';

const apiPathAuthChangeEmail = '/auth/change-email/';
const apiPathAuthRegistration = '/auth/registration/';
const apiPathAuthDeleteRegistration = '/auth/registration/delete/';
const apiPathAuthResetPassword = '/auth/reset-password/';
const apiPathAuthChangePassword = '/auth/change-password/';
const apiPathAuthLogin = '/token/';
const apiPathAuthTokenVerify = '/token/verify';
const apiPathAuthTokenRefresh = '/token/refresh';

const storageKeyAccessToken = '';
const storageKeyRefreshToken = 'refresh_token';
const storageKeyProtocol = 'protocol';
const storageKeyHostname = 'hostname';
const storageKeyPort = 'port';
