require 'rubygems'
require 'relax'

require 'remit/common'

module Remit
  class Amount < BaseResponse
    parameter :currency_code
    parameter :value, :type => :float
  end

  class TemporaryDeclinePolicy < BaseResponse
    parameter :temporary_decline_policy_type
    parameter :implicit_retry_timeout_in_mins
  end

  class DescriptorPolicy < BaseResponse
    parameter :soft_descriptor_type
    parameter :CS_owner
  end

  class ChargeFeeTo
    CALLER = 'Caller'
    RECIPIENT = 'Recipient'
  end

  class Error < BaseResponse
    parameter :code
    parameter :message
  end

  class InstrumentStatus
    ALL = 'ALL'
    ACTIVE = 'Active'
    INACTIVE = 'Inactive'
  end

  class PaymentMethods
    BALANCE_aFER = 'abt'
    BANK_ACCOUNT = 'ach'
    CREDIT_CARD = 'credit card'
    PREPAID = 'prepaid'
    DEBT = 'Debt'
  end

  class ServiceError < BaseResponse
    parameter :error_type
    parameter :is_retriable
    parameter :error_code
    parameter :reason_text

    class ErrorType
      SYSTEM = 'System'
      BUSINESS = 'Business'
    end
  end

  class ResponseStatus
    SUCCESS = 'Success'
    FAILURE = 'Failure'
  end

  class Token < BaseResponse
    parameter :token_id
    parameter :friendly_name
    parameter :token_status
    parameter :date_installed, :type => :time
    #parameter :caller_installed
    parameter :caller_reference
    parameter :token_type
    parameter :old_token_id
    #parameter :payment_reason

    class TokenStatus
      ACTIVE = 'Active'
      INACTIVE = 'Inactive'
    end
  end

  class TokenUsageLimit < BaseResponse
    parameter :count
    parameter :limit
    parameter :last_reset_amount
    parameter :last_reset_count
    parameter :last_reset_time_stamp
  end


  class ResponseMetadata < BaseResponse
    parameter :request_id
  end

  class TransactionPart < Remit::BaseResponse
    parameter :account_id
    parameter :role
    parameter :name
    parameter :reference
    parameter :description
    parameter :fee_paid, :type => Amount
  end
    
  class Transaction < BaseResponse
    
    parameter :caller_name
    parameter :caller_token_id
    parameter :caller_reference
    parameter :caller_description
    parameter :caller_transaction_date, :type => :time
    parameter :date_completed, :type => :time
    parameter :date_received, :type => :time
    parameter :error_code
    parameter :error_message
    parameter :fees, :type => Amount
    parameter :fps_fees_paid_by, :element=>"FPSFeesPaidBy"
    parameter :fps_operation, :element=>"FPSOperation"
    parameter :meta_data
    parameter :payment_method
    parameter :recipient_name
    parameter :recipient_email
    parameter :recipient_token_id
    parameter :related_transactions
    parameter :sender_email
    parameter :sender_name
    parameter :sender_token_id
    parameter :transaction_status
    parameter :status_code
    parameter :status_history
    parameter :status_message
    parameter :transaction_amount, :type => Amount
    parameter :transaction_id
    parameter :transaction_parts, :collection => TransactionPart, :element=>"TransactionPart"
  end
  
  
  
  
  class TransactionStatusResponse < BaseResponse
    parameter :transaction_id
    parameter :transaction_status
    parameter :status
    parameter :new_sender_token_usage, :type => TokenUsageLimit

    def which_status
      self.status.blank? ? self.transaction_status : self.status
    end
    
    %w(reserved success failure initiated reinitiated temporary_decline pending).each do |status_name|
      define_method("#{status_name}?") do
        self.which_status == Remit::TransactionStatus.const_get(status_name.sub('_', '').upcase)
      end
    end
  end

  class TransactionStatus
    RESERVED          = 'Reserved'
    SUCCESS           = 'Success'
    FAILURE           = 'Failure'
    INITIATED         = 'Initiated'
    REINITIATED       = 'Reinitiated'
    TEMPORARYDECLINE  = 'TemporaryDecline'
    PENDING           = 'Pending'
  end

  class TokenType
    SINGLE_USE = 'SingleUse'
    MULTI_USE = 'MultiUse'
    RECURRING = 'Recurring'
    UNRESTRICTED = 'Unrestricted'
  end

  class PipelineName
    SINGLE_USE = 'SingleUse'
    MULTI_USE = 'MultiUse'
    RECURRING = 'Recurring'
    RECIPIENT = 'Recipient'
    SETUP_PREPAID = 'SetupPrepaid'
    SETUP_POSTPAID = 'SetupPostpaid'
    EDIT_TOKEN = 'EditToken'
  end

  class PipelineStatusCode
    CALLER_EXCEPTION  = 'CE'  # problem with your code
    SYSTEM_ERROR      = 'SE'  # system error, try again
    SUCCESS_ABT       = 'SA'  # successful payment with Amazon balance
    SUCCESS_ACH       = 'SB'  # successful payment with bank transfer
    SUCCESS_CC        = 'SC'  # successful payment with credit card
    ABORTED           = 'A'   # user aborted payment
    PAYMENT_METHOD_MISMATCH     = 'PE'  # user does not have payment method requested
    PAYMENT_METHOD_UNSUPPORTED  = 'NP'  # account doesn't support requested payment method
    INVALID_CALLER    = 'NM'  # you are not a valid 3rd party caller to the transaction
    SUCCESS_RECIPIENT_TOKEN_INSTALLED = 'SR'
  end

  module RequestTypes
    class Amount < Remit::Request
      parameter :value
      parameter :currency_code
    end

    class TemporaryDeclinePolicy < Remit::Request
      parameter :temporary_decline_policy_type
      parameter :implicit_retry_timeout_in_mins
    end

    class DescriptorPolicy < Remit::Request
      parameter :soft_descriptor_type
      parameter :CS_owner
    end
  end

  class Operation
    PAY             = "Pay"
    REFUND          = "Refund"
    SETTLE          = "Settle"
    SETTLE_DEBT     = "SettleDebt"
    WRITE_OFF_DEBT  = "WriteOffDebt"
    FUND_PREPAID    = "FundPrepaid"
  end
end
