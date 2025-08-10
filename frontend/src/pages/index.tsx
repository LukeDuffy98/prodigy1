import { useState, useEffect } from 'react'
import { apiService } from '@/services/apiService'

export default function Home() {
  const [data, setData] = useState<any>(null)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const fetchData = async () => {
    setLoading(true)
    setError(null)
    try {
      const result = await apiService.getData()
      setData(result)
    } catch (err) {
      setError('Failed to fetch data')
      console.error('Error:', err)
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    fetchData()
  }, [])

  return (
    <div className="container">
      <main className="main">
        <h1 className="title">
          Welcome to <span className="highlight">Prodigy1</span>
        </h1>

        <p className="description">
          A modern web application powered by Azure services
        </p>

        <div className="card">
          <h2>Azure Function Data</h2>
          {loading && <p>Loading...</p>}
          {error && <p className="error">{error}</p>}
          {data && (
            <div>
              <p><strong>Message:</strong> {data.message}</p>
              <p><strong>Timestamp:</strong> {data.timestamp}</p>
            </div>
          )}
          <button onClick={fetchData} disabled={loading}>
            Refresh Data
          </button>
        </div>
      </main>

      <style jsx>{`
        .container {
          min-height: 100vh;
          padding: 0 2rem;
          display: flex;
          flex-direction: column;
          justify-content: center;
          align-items: center;
        }

        .main {
          padding: 4rem 0;
          flex: 1;
          display: flex;
          flex-direction: column;
          justify-content: center;
          align-items: center;
        }

        .title {
          margin: 0;
          line-height: 1.15;
          font-size: 4rem;
          text-align: center;
        }

        .highlight {
          color: #0070f3;
        }

        .description {
          margin: 4rem 0;
          line-height: 1.5;
          font-size: 1.5rem;
          text-align: center;
        }

        .card {
          margin: 1rem;
          padding: 1.5rem;
          text-align: left;
          color: inherit;
          text-decoration: none;
          border: 1px solid #eaeaea;
          border-radius: 10px;
          transition: color 0.15s ease, border-color 0.15s ease;
          max-width: 300px;
        }

        .card:hover {
          color: #0070f3;
          border-color: #0070f3;
        }

        .card h2 {
          margin: 0 0 1rem 0;
          font-size: 1.5rem;
        }

        .card p {
          margin: 0;
          font-size: 1.25rem;
          line-height: 1.5;
        }

        .error {
          color: #ff0000;
        }

        button {
          background-color: #0070f3;
          color: white;
          border: none;
          padding: 0.5rem 1rem;
          border-radius: 5px;
          cursor: pointer;
          margin-top: 1rem;
        }

        button:disabled {
          background-color: #ccc;
          cursor: not-allowed;
        }
      `}</style>
    </div>
  )
}
