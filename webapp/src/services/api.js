const BASE_URL = 'http://localhost:3001/';
const TOKEN_STORAGE_KEY = 'auth_token';

const defaultHeaders = {
  'Content-Type': 'application/json',
};

const getToken = () => {
  if (typeof window !== 'undefined') {
    return localStorage.getItem(TOKEN_STORAGE_KEY);
  }
  return null;
};

const setToken = (token) => {
  if (typeof window !== 'undefined') {
    localStorage.setItem(TOKEN_STORAGE_KEY, token);
  }
};

const removeToken = () => {
  if (typeof window !== 'undefined') {
    localStorage.removeItem(TOKEN_STORAGE_KEY);
  }
};

const buildUrl = (endpoint, params) => {
  const url = new URL(`${BASE_URL}${endpoint}`);
  if (params) {
    Object.keys(params).forEach(key => url.searchParams.append(key, params[key]));
  }
  return url.toString();
};

const buildHeaders = (customHeaders = {}) => {
  const headers = { ...defaultHeaders, ...customHeaders };
  
  const token = getToken();
  if (token) {
    headers.Authorization = `Bearer ${token}`;
  }
  
  return headers;
};

const handleResponse = async (response) => {
  if (!response.ok) {
    const errorData = await response.json().catch(() => ({ message: 'Unknown error' }));
    throw new Error(errorData.message || `HTTP ${response.status}: ${response.statusText}`);
  }
  return response.json();
};

const get = async (endpoint, options = {}) => {
  const { params, headers: customHeaders } = options;
  const url = buildUrl(endpoint, params);
  const headers = buildHeaders(customHeaders);

  const response = await fetch(url, {
    method: 'GET',
    headers,
  });

  return handleResponse(response);
};

const post = async (endpoint, body, options = {}) => {
  const { params, headers: customHeaders } = options;
  const url = buildUrl(endpoint, params);
  const headers = buildHeaders(customHeaders);

  const response = await fetch(url, {
    method: 'POST',
    headers,
    body: JSON.stringify(body),
  });

  return handleResponse(response);
};

const put = async (endpoint, body, options = {}) => {
  const { params, headers: customHeaders } = options;
  const url = buildUrl(endpoint, params);
  const headers = buildHeaders(customHeaders);

  const response = await fetch(url, {
    method: 'PUT',
    headers,
    body: JSON.stringify(body),
  });

  return handleResponse(response);
};

const del = async (endpoint, options = {}) => {
  const { params, headers: customHeaders } = options;
  const url = buildUrl(endpoint, params);
  const headers = buildHeaders(customHeaders);

  const response = await fetch(url, {
    method: 'DELETE',
    headers,
  });

  return handleResponse(response);
};

export const api = {
  get,
  post,
  put,
  del,
  setToken,
  removeToken,
  getToken,
};