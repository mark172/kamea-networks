class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  # GET /contacts
  # GET /contacts.json
  def index
    # @contacts = Contact.all
    redirect_to root_path
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
    @title = "Contact Kamea Networks | Kamea Networks"
  end

  # GET /contacts/1/edit
  def edit
    redirect_to root_path
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if verify_recaptcha(model: @contact) && @contact.save
        
        first_name = params[:contact][:first_name]
        last_name = params[:contact][:last_name]
        email = params[:contact][:email]
        phone = params[:contact][:phone]
        message = params[:contact][:message]
        
        ContactMailer.contact_email(first_name, last_name, email, phone, message).deliver_now
        
        flash[:success] = "Your request for information was successfully sent."
        format.html { redirect_to new_contact_path }
        format.json { render :show, status: :created, location: @contact }
      else
        flash[:danger] = "Unable to send. Please check for errors and let us know you're a human by checking the Captcha box"
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    redirect_to root_path
    # respond_to do |format|
    #   if @contact.update(contact_params)
    #     format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @contact }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @contact.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    redirect_to root_path
    # @contact.destroy
    # respond_to do |format|
    #   format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:todays_date, :first_name, :last_name, :email, :phone, :message)
    end
end


#test