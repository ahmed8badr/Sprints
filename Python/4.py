import csv
import datetime

class ContactBook:
    def __init__(self):
        # field names for the csv file
        self.fieldnames = ['name', 'email', 'phone_numbers', 'address', 'insertion_date']
        # generate file name with current date
        self.filename = "contactbook_{}.csv".format(datetime.datetime.now().strftime("%d%m%Y"))

    def create_contact(self, name, email, phone_numbers, address):
        # get the current date and time
        insertion_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        # open the file in append mode
        with open(self.filename, 'a', newline='') as csvfile:
            # create a DictWriter object
            writer = csv.DictWriter(csvfile, fieldnames=self.fieldnames)
            # write the contact information to the file
            writer.writerow({
                'name': name,
                'email': email,
                'phone_numbers': phone_numbers,
                'address': address,
                'insertion_date': insertion_date
            })
    def update_contact(self, name, email=None, phone_numbers=None, address=None):
        # get all contacts from the file
        contacts = self.list_contacts()
        # loop through the contacts
        for contact in contacts:
            # if the name matches the contact to update
            if contact['name'] == name:
                # update the contact information
                if email is not None:
                    contact['email'] = email
                if phone_numbers is not None:
                    contact['phone_numbers'] = phone_numbers
                if address is not None:
                    contact['address'] = address
                # write the updated contacts to the file
                self.write_contacts_to_file(contacts)
                break
    def delete_contact(self, name):
        # get all contacts from the file
        contacts = self.list_contacts()
        # create a list of contacts that do not have the specified name
        updated_contacts = [contact for contact in contacts if contact['name'] != name]
        # write the updated contacts to the file
        self.write_contacts_to_file(updated_contacts)
    def list_contacts(self):
        # list to store the contacts
        contacts = []
        # open the file in read mode
        with open(self.filename, 'r') as csvfile:
            # create a DictReader object
            reader = csv.DictReader(csvfile)
            # loop through the rows
            for row in reader:
                contacts.append(row)
        return contacts
    def write_contacts_to_file(self, contacts):
        # open the file in write mode
        with open(self.filename, 'w', newline='') as csvfile:
            # create a DictWriter object
            writer = csv.DictWriter(csvfile, fieldnames=self.fieldnames)
            # write the header row
            writer.writeheader()
            # write the contacts to the file
            writer.writerows(contacts)

if __name__ == '__main__':
    # create an instance of the ContactBook class
    contact_book = ContactBook()
    while True:
        print("Welcome to the Contact Book!")
        print("1. Create a contact")
        print("2. Update a contact")
        print("3. Delete a contact")
        print("4. List all contacts")
        print("5. Exit")
        # get the user's choice
        choice = input("Enter your choice: ")

        if choice == '1':
            # get the contact information from the user
            name = input("Enter name: ")
            email = input("Enter email: ")
            phone_numbers = input("Enter phone numbers: ")
            address = input("Enter address: ")
            # call the create_contact method
            contact_book.create_contact(name, email, phone_numbers, address)
            print("Contact created successfully!")
        elif choice == '2':
            # get the name of the contact to update
            name = input("Enter name of contact to update: ")
            # get the updated contact information
            email = input("Enter new email (leave blank if not updating): ")
            phone_numbers = input("Enter new phone numbers (leave blank if not updating): ")
            address = input("Enter new address (leave blank if not updating): ")
            # call the update_contact method
            contact_book.update_contact(name, email, phone_numbers, address)
            print("Contact updated successfully!")
        elif choice == '3':
            # get the name of the contact to delete
            name = input("Enter name of contact to delete: ")
            # call the delete_contact method
            contact_book.delete_contact(name)
            print("Contact deleted successfully!")
        elif choice == '4':
            # call the list_contacts method
            contacts = contact_book.list_contacts()
            # print the contacts
            for contact in contacts:
                print(contact)
        elif choice == '5':
            break
        else:
            print("Invalid choice. Please enter a valid option.")
