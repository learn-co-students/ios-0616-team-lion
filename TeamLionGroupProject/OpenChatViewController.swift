//
//  OpenChatViewController.swift
//  TeamLionGroupProject
//
//  Created by David Park on 8/18/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class OpenChatViewController: JSQMessagesViewController {
	
	var parentNavigationController : UINavigationController?
	
	var chatType = "OpenChat"
	
	var messages = [JSQMessage]()
	var avatarDict = [String: JSQMessagesAvatarImage]()

	var messageRef = FIRDatabase.database().reference().child("messages")
	var blockedString = ""
	var filteredMessages = [JSQMessage]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if (chatType == "OpenChat") {
			messageRef = FIRDatabase.database().reference().child("messages")
		} else {
			let uniqueID = ["myID", "tappedUserID"].sort().joinWithSeparator("-")
			messageRef = FIRDatabase.database().reference().child(uniqueID)
		}
		
		if let currentUser = FIRAuth.auth()?.currentUser {
			self.senderId = currentUser.uid
			self.senderDisplayName = "TEMP"
			
			if currentUser.anonymous == true {
				self.senderDisplayName = "Anonymous"
			} else {
				self.senderDisplayName = "\(currentUser.displayName!)"
			}
		}
		grabBlockedList()
		observeMessages()
	}
    
    override func viewWillAppear(animated: Bool) {
		
    }
	
	func swipeDetected() {
		tabBarController?.selectedIndex = 0
	}
	
	func observeUsers(id: String) {
		
		FIRDatabase.database().reference().child("users").child(id).observeEventType(.Value, withBlock: {
			snapshot in
			if let dict = snapshot.value as? [String: AnyObject] {
				let avatarUrl = dict["picture"] as! String
				//print("profileUrl = \(avatarUrl)")
				self.setupAvatar(avatarUrl, messageId: id)
			}
		})
	}
	
	func setupAvatar(url: String, messageId: String) {
		
		if url != "" {
			let fileUrl = NSURL(string: url)
			let data = NSData(contentsOfURL: fileUrl!)
			let image = UIImage(data: data!)
			let userImg = JSQMessagesAvatarImageFactory.avatarImageWithImage(image, diameter: 30)
			avatarDict[messageId] = userImg
			
		} else {
			avatarDict[messageId] = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "DefaultProfilePicture"), diameter: 30)
			
		}
		collectionView.reloadData()
	}
	
	func observeMessages() {
		messageRef.observeEventType(.ChildAdded, withBlock: { snapshot in
			if let dict = snapshot.value as? [String: AnyObject] {
				let mediaType = dict["MediaType"] as! String
				let senderId = dict["senderId"] as! String
				let senderName = dict["senderName"] as! String
				
				self.observeUsers(senderId)
				
				switch mediaType {
				case "TEXT":
					let text = dict["text"] as! String
					self.messages.append(JSQMessage(senderId: senderId, displayName: senderName, text: text))
					
				case "PHOTO":
					let fileUrl = dict["fileUrl"] as! String
					let url = NSURL(string: fileUrl)
					let data = NSData(contentsOfURL: url!)
					let picture = UIImage(data: data!)
					let photo = JSQPhotoMediaItem(image: picture)
					self.messages.append(JSQMessage(senderId: senderId, displayName: senderName, media: photo))
					
					if self.senderId == senderId {
						photo.appliesMediaViewMaskAsOutgoing = true
					} else {
						photo.appliesMediaViewMaskAsOutgoing = false
					}
					
				case "VIDEO":
					let fileUrl = dict["fileUrl"] as! String
					let video = NSURL(string: fileUrl)
					let videoItem = JSQVideoMediaItem(fileURL: video, isReadyToPlay: true)
					self.messages.append(JSQMessage(senderId: senderId, displayName: senderName, media: videoItem))
					
					if self.senderId == senderId {
						videoItem.appliesMediaViewMaskAsOutgoing = true
					} else {
						videoItem.appliesMediaViewMaskAsOutgoing = false
					}
					
				default:
					print("Unknown Data Type")
				}
				
				self.collectionView.reloadData()
			}
		})
	}
	
	override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
		
		//		messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
		//		collectionView.reloadData()
		//		print(messages)
		
		let newMessage = messageRef.childByAutoId()
		let messageData = ["text": text, "senderId": senderId, "senderName": senderDisplayName, "MediaType": "TEXT"]
		
		newMessage.setValue(messageData)
		self.finishSendingMessage()
		
	}
	
	override func didPressAccessoryButton(sender: UIButton!) {
		print("did print accessory button")
		
		let sheet = UIAlertController(title: "Media Messages", message: "Please select a media", preferredStyle: UIAlertControllerStyle.ActionSheet)
		let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert: UIAlertAction) in }
		
		let photoLibrary = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default) { (alert: UIAlertAction) in
			self.getMediaFrom(kUTTypeImage)
		}
		
		let videoLibrary = UIAlertAction(title: "Video Library", style: UIAlertActionStyle.Default) { (alert: UIAlertAction) in
			self.getMediaFrom(kUTTypeMovie)
		}
		
		sheet.addAction(photoLibrary)
		sheet.addAction(videoLibrary)
		sheet.addAction(cancel)
		print("Before Frame \(self.view.frame)")
		self.presentViewController(sheet, animated: true, completion: nil)

		//		let imagePicker = UIImagePickerController()
		//		imagePicker.delegate = self
		//		self.presentViewController(imagePicker, animated: true, completion: nil)
	}
	
	func getMediaFrom(type: CFString) {
		print(type)
		let mediaPicker = UIImagePickerController()
		mediaPicker.delegate = self
		mediaPicker.mediaTypes = [type as String]
		
		self.presentViewController(mediaPicker, animated: true, completion: nil)
	}
	
	func filterMessages() {
		filteredMessages.removeAll()
		for message in messages {
			print("this is the blockedstring in filter message \(blockedString)")
			if (!blockedString.containsString(message.senderId)) {
				print("SenderID \(message.senderId)")
				filteredMessages.append(message)
			}
		}
		print("filterdmessage \(filteredMessages)")
	}
	
	override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
		
		return filteredMessages[indexPath.item]
	}
	
	override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
		let message = messages[indexPath.item]
		let bubbleFactory = JSQMessagesBubbleImageFactory()
		if message.senderId == self.senderId {
			
			return bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.cyanColor())
		} else {
			
			return bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.blueColor())
		}
	}
	
	override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
		let message = filteredMessages[indexPath.item]
		
		print(avatarDict[message.senderId])
		return avatarDict[message.senderId]
		
		//return JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "ProfilePicture"), diameter: 30)
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		self.filterMessages()
		print(self.filteredMessages.count)
		return filteredMessages.count
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
		
		return cell
	}
	
	func grabBlockedList() {
		let userRef = FIRDatabase.database().reference()
		print("USERREF \(userRef)")
		userRef.child("users").child(self.senderId).observeEventType(.ChildAdded, withBlock: { (snapshot) in
			
			print("SNAPSHOT " + String(snapshot))

			if (String(snapshot).containsString("Snap (blockedUsers) ")) {
				self.blockedString = snapshot.value as! String
				print("This is important \(self.blockedString)")
			}
		})
	}
	
	//I can refactor this entire function now that I have the grabBlockedList() function
	override func collectionView(collectionView: JSQMessagesCollectionView!, didTapAvatarImageView avatarImageView: UIImageView!, atIndexPath indexPath: NSIndexPath!) {

		print("didTapAvatarAtIndexPath \(indexPath.item)")
		let message = messages[indexPath.item]
		//print("SENDERID \(message.senderId)")
		//print("FIRAUTH \(FIRAuth.auth()?.currentUser!.uid)")
		
		let alertController = UIAlertController(title: "Block \(message.senderDisplayName)", message: "would you like to block this user?", preferredStyle: .Alert)
		let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
			
		}
		alertController.addAction(cancelAction)
		
		let OKAction = UIAlertAction(title: "BLOCK", style: .Default) { (action) in
			print("User BLOCKED")
			
			let userRef = FIRDatabase.database().reference()
			print("USERREF \(userRef)")
			userRef.child("users").child(self.senderId).observeEventType(.ChildAdded, withBlock: { (snapshot) in
				
				print("SNAPSHOT " + String(snapshot))
				
				if !(self.blockedString.containsString(String(message.senderId))) {
					
					if (String(snapshot).containsString("Snap (blockedUsers) ")) {
						
						print(self.blockedString)
						self.blockedString.appendContentsOf(String(message.senderId))
						print("AFTERSTRING \(self.blockedString)")
						
						//update child to firebase
						
						userRef.child("users").child(self.senderId).updateChildValues(["blockedUsers" : self.blockedString])
						
						let confirmAlertController = UIAlertController(title: "BLOCKED", message: "\(message.senderDisplayName) has been blocked", preferredStyle: .Alert)
						
						let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
						confirmAlertController.addAction(OKAction)
						
						self.presentViewController(confirmAlertController, animated: true, completion: nil)
						
					}
					
				} else {
					
					let errorAlertController = UIAlertController(title: "Error", message: "\(message.senderDisplayName) has already been blocked", preferredStyle: .Alert)
					
					let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
					errorAlertController.addAction(OKAction)
					
					self.presentViewController(errorAlertController, animated: true, completion: nil)
				}

			})
			
		}
		alertController.addAction(OKAction)
		
		if (message.senderId != self.senderId) {
			self.presentViewController(alertController, animated: true) {
				
			}
		}
	}

	override func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!) {
		print("Tapped")
		print("didtapmessegeBubbleAtIndexPath: \(indexPath.item)")
		let message = messages[indexPath.item]
		
		if message.isMediaMessage {
			if let mediaItem = message.media as? JSQVideoMediaItem {
				let player = AVPlayer(URL: mediaItem.fileURL)
				let playerViewController = AVPlayerViewController()
				playerViewController.player = player
				self.presentViewController(playerViewController, animated: true, completion: nil)
			}
		}
	}
	
	func sendMedia(picture: UIImage?, video: NSURL?) {
		print(picture)
		print(FIRStorage.storage().reference())
		if let picture = picture {
			let filePath = "\(FIRAuth.auth()!.currentUser!)/\(NSDate.timeIntervalSinceReferenceDate())"
			print(filePath)
			let data = UIImageJPEGRepresentation(picture, 0.2)
			let metadata = FIRStorageMetadata()
			metadata.contentType = "image/jpg"
			FIRStorage.storage().reference().child(filePath).putData(data!, metadata: metadata) { (metadata, error) in
				if error != nil {
					print(error?.localizedDescription)
					return
				}
				
				let fileUrl = metadata!.downloadURLs![0].absoluteString
				
				let newMessage = self.messageRef.childByAutoId()
				let messageData = ["fileUrl": fileUrl, "senderId": self.senderId, "senderName": self.senderDisplayName, "MediaType": "PHOTO"]
				newMessage.setValue(messageData)
			}
			
		} else if let video = video {
			let filePath = "\(FIRAuth.auth()!.currentUser!)/\(NSDate.timeIntervalSinceReferenceDate())"
			print(filePath)
			let data = NSData(contentsOfURL: video)
			let metadata = FIRStorageMetadata()
			metadata.contentType = "video/mp4"
			FIRStorage.storage().reference().child(filePath).putData(data!, metadata: metadata) { (metadata, error) in
				if error != nil {
					print(error?.localizedDescription)
					return
				}
				
				let fileUrl = metadata!.downloadURLs![0].absoluteString
				
				let newMessage = self.messageRef.childByAutoId()
				let messageData = ["fileUrl": fileUrl, "senderId": self.senderId, "senderName": self.senderDisplayName, "MediaType": "VIDEO"]
				newMessage.setValue(messageData)
			}
		}
	}
}

extension OpenChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		print("Did finish picking")
		
		//get the image
		print(info)
		if let picture = info[UIImagePickerControllerOriginalImage] as? UIImage {
			
			sendMedia(picture, video: nil)
		} else if let video = info[UIImagePickerControllerMediaURL] as? NSURL {
			let videoItem = JSQVideoMediaItem(fileURL: video, isReadyToPlay: true)
			messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: videoItem))
			sendMedia(nil, video: video)
		}
		self.dismissViewControllerAnimated(true, completion: nil)
		
		collectionView.reloadData()
	}
}

