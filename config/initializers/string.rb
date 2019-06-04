# coding: utf-8
class String

  def to_boolean
    %w(1 true t verdadeiro v on).include?(self.downcase)
  end

  def is_numeric?
    text = self.strip
    return false if text =~ /(.)(-)+/
    return false if text =~ /[^0-9,.-]/
    Float(text.delocalize_currency) != nil rescue false
  end

  def is_json?
    is_array? || is_hash?
  end

  def is_array?
    return true if self =~ /^(\[)(.*)(\])$/
    false
  end

  def is_hash?
    return true if self =~ /^({)(.*)(})$/
    false
  end

  def is_email?
    # regex = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
    regex = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,6}$/i
    self =~ regex ? true : false
  end

  def is_url?
    regex = /^(http|https):\/\/|[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?$/ix
    self =~ regex ? true : false
  end

  def complete_http(protocol='http')
    return "#{protocol}://#{self}" if self.is_url? && !(self =~ /^(http|https):\/\//)
    self
  end

  def is_date_bd?
    # Ex.: "2011-12-32"
    # Não verifica se mês tem 31 ou não
    # e muito menos se 29 de Fev.  (ano bissexto)
    # vai sempre retornar true nessas particularidades acima, portanto 31 de Fev retorna true
    # TODO: consertar os problemas acima
    regex = /^\d\d\d\d[\-](0[1-9]|1[0-2])[\-](0[1-9]|[12][1-9]|3[01])$/ #data válida
    self =~ regex ? true : false
  end

  def is_date?
    # Ex.: "2014-12-31"
    # Ex.: "31/12/2014"
    # Verifica se mês tem 31 ou não, mesmo se 29 de Fev. (ano bissexto)
    regex_pt_br = /^(0[1-9]|[1-2][0-9]|3[01])[\/](0[1-9]|1[0-2])[\/](\d\d\d\d)$/
    regex_bd    = /^(\d\d\d\d)[\-](0[1-9]|1[0-2])[\-](0[1-9]|[1-2][0-9]|3[01])$/

    match_pt = self.match(regex_pt_br)
    match_bd = self.match(regex_bd)
    return false unless match_pt || match_bd

    dia, mes, ano = match_pt[1], match_pt[2], match_pt[3] if match_pt
    dia, mes, ano = match_bd[3], match_bd[2], match_bd[1] if match_bd
    return false if dia.blank? || mes.blank? || ano.blank?

    ultimo_dia = Date.new(ano.to_i, mes.to_i).end_of_month.day
    return false if dia.to_i > ultimo_dia.to_i
    true
  end

end