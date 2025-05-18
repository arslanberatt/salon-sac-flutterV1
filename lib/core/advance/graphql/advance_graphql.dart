const String fetchAdvanceRequestsQuery = """
  query {
    advanceRequests {
      id
      amount
      reason
      status
      createdAt
      employee {
        id
        name
      }
    }
  }
""";

const String approveAdvanceMutation = """
  mutation ApproveAdvanceRequest(\$id: ID!) {
    approveAdvanceRequest(id: \$id) {
      id
      status
    }
  }
""";

const String rejectAdvanceMutation = """
  mutation RejectAdvanceRequest(\$id: ID!) {
    rejectAdvanceRequest(id: \$id) {
      id
      status
    }
  }
""";

const String createAdvanceRequestMutation = """
  mutation CreateAdvanceRequest(\$amount: Float!, \$reason: String) {
    createAdvanceRequest(amount: \$amount, reason: \$reason) {
      id
      status
    }
  }
""";
