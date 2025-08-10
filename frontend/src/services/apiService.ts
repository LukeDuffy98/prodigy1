import axios from 'axios'

const API_BASE_URL = process.env.NEXT_PUBLIC_API_BASE_URL || 'http://localhost:7071/api'

// Create axios instance with default configuration
const apiClient = axios.create({
  baseURL: API_BASE_URL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  },
})

// Request interceptor for adding auth tokens
apiClient.interceptors.request.use(
  (config) => {
    // Add auth token if available
    const token = typeof window !== 'undefined' ? localStorage.getItem('authToken') : null
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// Response interceptor for handling errors
apiClient.interceptors.response.use(
  (response) => {
    return response
  },
  (error) => {
    if (error.response?.status === 401) {
      // Handle unauthorized access
      if (typeof window !== 'undefined') {
        localStorage.removeItem('authToken')
        window.location.href = '/login'
      }
    }
    return Promise.reject(error)
  }
)

// API service functions
export const apiService = {
  // Example GET request
  async getData() {
    try {
      const response = await apiClient.get('/getData')
      return response.data
    } catch (error) {
      console.error('Error fetching data:', error)
      throw error
    }
  },

  // Example POST request
  async createData(data: any) {
    try {
      const response = await apiClient.post('/createData', data)
      return response.data
    } catch (error) {
      console.error('Error creating data:', error)
      throw error
    }
  },

  // Example PUT request
  async updateData(id: string, data: any) {
    try {
      const response = await apiClient.put(`/updateData/${id}`, data)
      return response.data
    } catch (error) {
      console.error('Error updating data:', error)
      throw error
    }
  },

  // Example DELETE request
  async deleteData(id: string) {
    try {
      const response = await apiClient.delete(`/deleteData/${id}`)
      return response.data
    } catch (error) {
      console.error('Error deleting data:', error)
      throw error
    }
  },

  // Health check
  async healthCheck() {
    try {
      const response = await apiClient.get('/health')
      return response.data
    } catch (error) {
      console.error('Health check failed:', error)
      throw error
    }
  }
}

export default apiService
