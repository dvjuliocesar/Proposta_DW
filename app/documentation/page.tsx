import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { FileText, Database, BarChart3, Settings, Users, Shield } from "lucide-react"

export default function DocumentationPage() {
  return (
    <div className="min-h-screen bg-background">
      <div className="container mx-auto px-4 py-8">
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-foreground mb-4">Documentação</h1>
          <p className="text-lg text-muted-foreground">Guia completo para implementação e uso do Data Warehouse</p>
        </div>

        <div className="grid lg:grid-cols-2 gap-6">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Database className="h-5 w-5 text-blue-500" />
                Estrutura do Banco
              </CardTitle>
              <CardDescription>Organização de databases, schemas e tabelas</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                <div>
                  <h4 className="font-semibold">Databases:</h4>
                  <ul className="text-sm text-muted-foreground space-y-1">
                    <li>
                      • <code>ECOMMERCE_DW</code> - Database principal
                    </li>
                  </ul>
                </div>
                <div>
                  <h4 className="font-semibold">Schemas:</h4>
                  <ul className="text-sm text-muted-foreground space-y-1">
                    <li>
                      • <code>STAGING</code> - Dados brutos
                    </li>
                    <li>
                      • <code>CORE</code> - Modelagem dimensional
                    </li>
                    <li>
                      • <code>ANALYTICS</code> - Views e agregações
                    </li>
                  </ul>
                </div>
                <Badge variant="secondary">Snowflake</Badge>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Settings className="h-5 w-5 text-green-500" />
                Pipeline ELT
              </CardTitle>
              <CardDescription>Processo automatizado de transformação</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                <div>
                  <h4 className="font-semibold">Procedures:</h4>
                  <ul className="text-sm text-muted-foreground space-y-1">
                    <li>
                      • <code>LOAD_STAGING_DATA</code>
                    </li>
                    <li>
                      • <code>TRANSFORM_TO_CORE</code>
                    </li>
                    <li>
                      • <code>UPDATE_ANALYTICS</code>
                    </li>
                    <li>
                      • <code>RUN_FULL_PIPELINE</code>
                    </li>
                  </ul>
                </div>
                <div>
                  <h4 className="font-semibold">Agendamento:</h4>
                  <p className="text-sm text-muted-foreground">Tasks automáticas executam o pipeline diariamente</p>
                </div>
                <Badge variant="secondary">Automatizado</Badge>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <BarChart3 className="h-5 w-5 text-purple-500" />
                Análises Disponíveis
              </CardTitle>
              <CardDescription>KPIs e métricas de negócio implementadas</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                <div>
                  <h4 className="font-semibold">Principais Análises:</h4>
                  <ul className="text-sm text-muted-foreground space-y-1">
                    <li>• Vendas por período temporal</li>
                    <li>• Performance de produtos</li>
                    <li>• Segmentação de clientes</li>
                    <li>• Análise geográfica</li>
                    <li>• Tendências e sazonalidade</li>
                  </ul>
                </div>
                <Badge variant="secondary">Business Intelligence</Badge>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Users className="h-5 w-5 text-orange-500" />
                Roles e Permissões
              </CardTitle>
              <CardDescription>Controle de acesso e segurança</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                <div>
                  <h4 className="font-semibold">Roles Criadas:</h4>
                  <ul className="text-sm text-muted-foreground space-y-1">
                    <li>
                      • <code>DW_ADMIN</code> - Acesso completo
                    </li>
                    <li>
                      • <code>DW_ANALYST</code> - Leitura analytics
                    </li>
                    <li>
                      • <code>DW_DEVELOPER</code> - Desenvolvimento
                    </li>
                  </ul>
                </div>
                <div>
                  <h4 className="font-semibold">Warehouses:</h4>
                  <ul className="text-sm text-muted-foreground space-y-1">
                    <li>
                      • <code>DW_WH</code> - Warehouse principal
                    </li>
                  </ul>
                </div>
                <Badge variant="secondary">Segurança</Badge>
              </div>
            </CardContent>
          </Card>
        </div>

        <Card className="mt-8">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <FileText className="h-5 w-5 text-indigo-500" />
              Especificações Técnicas
            </CardTitle>
            <CardDescription>Detalhes de implementação e configuração</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="grid md:grid-cols-2 gap-6">
              <div>
                <h4 className="font-semibold mb-3">Fonte de Dados</h4>
                <ul className="text-sm text-muted-foreground space-y-2">
                  <li>
                    • <strong>API:</strong> Amazon Product Advertising API
                  </li>
                  <li>
                    • <strong>Formato:</strong> JSON
                  </li>
                  <li>
                    • <strong>Frequência:</strong> Diária
                  </li>
                  <li>
                    • <strong>Volume:</strong> ~10K produtos/dia
                  </li>
                </ul>
              </div>
              <div>
                <h4 className="font-semibold mb-3">Configurações</h4>
                <ul className="text-sm text-muted-foreground space-y-2">
                  <li>
                    • <strong>Warehouse Size:</strong> MEDIUM
                  </li>
                  <li>
                    • <strong>Auto Suspend:</strong> 5 minutos
                  </li>
                  <li>
                    • <strong>Auto Resume:</strong> Habilitado
                  </li>
                  <li>
                    • <strong>Retenção:</strong> 7 dias (Time Travel)
                  </li>
                </ul>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card className="mt-6">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Shield className="h-5 w-5 text-red-500" />
              Considerações de Segurança
            </CardTitle>
            <CardDescription>Boas práticas implementadas</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="grid md:grid-cols-2 gap-6">
              <div>
                <h4 className="font-semibold mb-3">Controle de Acesso</h4>
                <ul className="text-sm text-muted-foreground space-y-1">
                  <li>• Roles baseadas em função</li>
                  <li>• Princípio do menor privilégio</li>
                  <li>• Segregação de ambientes</li>
                </ul>
              </div>
              <div>
                <h4 className="font-semibold mb-3">Auditoria</h4>
                <ul className="text-sm text-muted-foreground space-y-1">
                  <li>• Logs de acesso habilitados</li>
                  <li>• Monitoramento de queries</li>
                  <li>• Alertas de uso anômalo</li>
                </ul>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}
