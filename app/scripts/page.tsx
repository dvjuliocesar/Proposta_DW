import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Play, Download, FileText } from "lucide-react"

const scripts = [
  {
    id: "01",
    title: "Setup Database Structure",
    description: "Criação da estrutura básica do Data Warehouse com databases, schemas e roles",
    file: "01_setup_database_structure.sql",
    category: "Setup",
  },
  {
    id: "02",
    title: "Staging Layer Tables",
    description: "Tabelas da camada de staging para receber dados brutos da API Amazon",
    file: "02_staging_layer_tables.sql",
    category: "Staging",
  },
  {
    id: "03",
    title: "Dimensional Model Core",
    description: "Modelagem dimensional Star Schema com tabela fato e dimensões",
    file: "03_dimensional_model_core.sql",
    category: "Core",
  },
  {
    id: "04",
    title: "ELT Pipeline Procedures",
    description: "Procedures para pipeline ELT automatizado e transformação de dados",
    file: "04_elt_pipeline_procedures.sql",
    category: "Pipeline",
  },
  {
    id: "05",
    title: "Analytics Layer",
    description: "Views e tabelas agregadas para análises e dashboards",
    file: "05_analytics_layer.sql",
    category: "Analytics",
  },
  {
    id: "06",
    title: "Sample Queries",
    description: "Consultas analíticas para responder perguntas de negócio",
    file: "06_sample_queries.sql",
    category: "Queries",
  },
  {
    id: "07",
    title: "Data Initialization",
    description: "Dados de exemplo para teste e validação do Data Warehouse",
    file: "07_data_initialization.sql",
    category: "Data",
  },
]

const getCategoryColor = (category: string) => {
  const colors = {
    Setup: "bg-blue-100 text-blue-800",
    Staging: "bg-green-100 text-green-800",
    Core: "bg-purple-100 text-purple-800",
    Pipeline: "bg-orange-100 text-orange-800",
    Analytics: "bg-pink-100 text-pink-800",
    Queries: "bg-indigo-100 text-indigo-800",
    Data: "bg-yellow-100 text-yellow-800",
  }
  return colors[category as keyof typeof colors] || "bg-gray-100 text-gray-800"
}

export default function ScriptsPage() {
  return (
    <div className="min-h-screen bg-background">
      <div className="container mx-auto px-4 py-8">
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-foreground mb-4">Scripts SQL</h1>
          <p className="text-lg text-muted-foreground">
            Scripts completos para implementação do Data Warehouse no Snowflake
          </p>
        </div>

        <div className="grid gap-6">
          {scripts.map((script) => (
            <Card key={script.id}>
              <CardHeader>
                <div className="flex items-start justify-between">
                  <div>
                    <CardTitle className="flex items-center gap-3">
                      <span className="text-2xl font-mono text-muted-foreground">{script.id}</span>
                      {script.title}
                    </CardTitle>
                    <CardDescription className="mt-2">{script.description}</CardDescription>
                  </div>
                  <Badge className={getCategoryColor(script.category)}>{script.category}</Badge>
                </div>
              </CardHeader>
              <CardContent>
                <div className="flex items-center gap-3">
                  <Button size="sm" className="flex items-center gap-2">
                    <Play className="h-4 w-4" />
                    Executar Script
                  </Button>
                  <Button variant="outline" size="sm" className="flex items-center gap-2 bg-transparent">
                    <FileText className="h-4 w-4" />
                    Ver Código
                  </Button>
                  <Button variant="outline" size="sm" className="flex items-center gap-2 bg-transparent">
                    <Download className="h-4 w-4" />
                    Download
                  </Button>
                  <span className="text-sm text-muted-foreground ml-auto">{script.file}</span>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>

        <Card className="mt-8">
          <CardHeader>
            <CardTitle>Ordem de Execução</CardTitle>
            <CardDescription>
              Execute os scripts na ordem numerada para garantir a criação correta da estrutura
            </CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-2">
              <p className="text-sm">
                <strong>1-2:</strong> Setup inicial e camada de staging
              </p>
              <p className="text-sm">
                <strong>3-4:</strong> Modelagem dimensional e pipeline ELT
              </p>
              <p className="text-sm">
                <strong>5-7:</strong> Camada analítica e dados de exemplo
              </p>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}
